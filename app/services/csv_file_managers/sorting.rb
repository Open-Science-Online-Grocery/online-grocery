# frozen_string_literal: true

module CsvFileManagers
  # responsible for generating and importing custom sorting csv files
  class Sorting < Base
    extend Memoist

    def self.headers
      [
        'Participant Id',
        'Product Id',
        'Product Rank'
      ]
    end

    def self.product_row(product)
      ['', product.id, '']
    end

    def initialize(condition)
      @custom_sortings = []
      super
    end

    private def records_previously_loaded?
      @condition.custom_sortings.exists?(sort_file: current_file)
    end

    private def current_file
      @condition.current_sort_file
    end
    memoize :current_file

    private def destroy_obsolete_records
      @condition.custom_sortings.where.not(sort_file: current_file).delete_all
    end

    private def columns
      %i[
        session_identifier
        condition_id
        sort_file_id
        product_id
        sort_order
      ]
    end

    private def process_row(row, row_number)
      return unless row_is_valid?(row, row_number)
      product = find_product(row_number, row[headers.second])
      return unless product
      # we are capturing an array of attributes instead of building records
      # because array-based importing is faster than record-based importing
      # when using the activerecord-import gem. these values map onto the
      # fields in `columns` above, plus the row number for error reporting.
      @custom_sortings << [
        row[headers.first],
        @condition.id,
        current_file.id,
        product.id,
        row[headers.last],
        row_number
      ]
    end

    private def row_is_valid?(row, row_number)
      headers.each do |header|
        if row[header].blank?
          add_error(row_number, "#{header} must have a value")
          return false
        end
      end
      true
    end

    private def find_product(row_number, product_id)
      product = product_cache[product_id.to_i]
      return product if product
      add_error(row_number, "Can't find product with Id #{product_id}")
      nil
    end

    private def finalize_records
      validate_records
      return if @errors.any?
      # drop the csv row number from the array; this is not saved to the db.
      values =  @custom_sortings.map { |attrs| attrs.first(5) }
      CustomSorting.import(columns, values, timestamps: false, validate: false)
    end

    # while this duplicates the validations on the CustomSorting model, doing
    # it here so that we can import with `validate: false` is substantially
    # faster than allowing rails to validate each created model object.
    private def validate_records
      validate_sort_order
      validate_session_identifier
      check_for_duplicates
    end

    private def validate_sort_order
      bad_records = @custom_sortings.select { |attrs| attrs.fifth.blank? }
      add_errors('Rows missing product rank', bad_records) if bad_records.any?
    end

    private def validate_session_identifier
      bad_records = @custom_sortings.select { |attrs| attrs.first.blank? }
      add_errors('Rows missing Participant Id', bad_records) if bad_records.any?
    end

    private def check_for_duplicates
      # grouping by session_identifier
      @custom_sortings.group_by(&:first).each_value do |sortings|
        flag_duplicate_sort_orders(sortings)
        flag_duplicate_product_ids(sortings)
      end
    end

    private def flag_duplicate_sort_orders(sortings)
      # grouping by sort_order
      sortings.group_by(&:fifth).values.select(&:many?).each do |group|
        add_errors(
          'Duplicate product rank specified for same Participant ID',
          group
        )
      end
    end

    private def flag_duplicate_product_ids(sortings)
      # grouping by product_id
      sortings.group_by(&:fourth).values.select(&:many?).each do |group|
        add_errors(
          'Duplicate product ID specified for for same Participant ID',
          group
        )
      end
    end

    private def add_errors(message, records)
      # records.map(&:last) => the csv row number
      @errors << "#{message}: rows #{records.map(&:last).to_sentence}"
    end

    private def product_cache
      Product.all.index_by(&:id)
    end
    memoize :product_cache
  end
end
