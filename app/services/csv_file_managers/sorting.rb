# frozen_string_literal

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
      custom_sorting = @condition.custom_sortings.build(
        session_identifier: row[headers.first],
        sort_file: current_file,
        product: product,
        sort_order: row[headers.last]
      )
      return if custom_sorting.save
      add_error(
        row_number,
        "#{custom_sorting.errors.full_messages.join(', ')}"
      )
    end

    private def row_is_valid?(row, row_number)
      headers.each do |header|
        if row[header].blank?
          add_error(row_number, "#{header} must have a value")
          return false
        end
      end
      return true
    end

    private def find_product(row_number, product_id)
      product = Product.find_by(id: product_id)
      return product if product
      add_error(row_number, "Can't find product with Id #{product_id}")
    end
  end
end
