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
      raise NotImplementedError
    end
  end
end
