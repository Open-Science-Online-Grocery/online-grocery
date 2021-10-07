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
      @condition.custom_sortings.where.not(sort_file: current_file).destroy_all
    end

    private def process_row(row, row_number)
      return unless row_is_valid?(row, row_number)
      product = find_product(row_number, row[headers.second])
      return unless product
      @custom_sortings << @condition.custom_sortings.build(
        session_identifier: row[headers.first],
        sort_file: current_file,
        product: product,
        sort_order: row[headers.last],
        csv_row_number: row_number
      )
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
      check_for_duplicates
      return if @errors.any?
      CustomSorting.import(@custom_sortings)
    end

    private def check_for_duplicates
      @custom_sortings.group_by(&:session_identifier).each_value do |sortings|
        flag_duplicate_sort_orders(sortings)
        flag_duplicate_product_ids(sortings)
      end
    end

    private def flag_duplicate_sort_orders(sortings)
      sortings.group_by(&:sort_order).values.select(&:many?).each do |group|
        add_duplicate_errors(
          'Duplicate product rank specified for same Participant ID',
          group
        )
      end
    end

    private def flag_duplicate_product_ids(sortings)
      sortings.group_by(&:product_id).values.select(&:many?).each do |group|
        add_duplicate_errors(
          'Duplicate product ID specified for for same Participant ID',
          group
        )
      end
    end

    private def add_duplicate_errors(message, records)
      @errors << "#{message}: rows #{records.map(&:csv_row_number).to_sentence}"
    end

    private def product_cache
      Product.all.index_by(&:id)
    end
    memoize :product_cache
  end
end
