# frozen_string_literal: true

module CsvFileManagers
  # contains base functionality for generating and importing csv config files
  class Base
    require 'csv'

    attr_reader :errors

    delegate :headers, to: :class

    def self.generate_csv(condition)
      CSV.generate(headers: true) do |csv|
        csv << headers

        condition.products.find_each do |product|
          csv << product_row(product)
        end
      end
    end

    def self.headers
      raise NotImplementedError
    end

    def self.product_row(product)
      raise NotImplementedError
    end

    # @param condition [Condition] the condition to import config for
    def initialize(condition)
      @condition = condition
      @errors = []
    end

    def import
      destroy_obsolete_records
      return true if records_previously_loaded? || current_file.nil?
      validate_file_type
      import_new_records if @errors.none?
      @errors.none?
    end

    private def validate_file_type
      extension = File.extname(current_file.path)
      @errors << 'The uploaded file must be a CSV' unless extension == '.csv'
    end

    private def import_new_records
      CSV.foreach(
        current_file.current_path,
        headers: true
      ).with_index(1) do |row, row_number|
        process_row(row, row_number)
      end
    end

    private def add_error(row_number, error_message)
      @errors << "Row #{row_number}: #{error_message}"
    end

    private def records_previously_loaded?
      raise NotImplementedError
    end

    private def current_file
      raise NotImplementedError
    end

    private def destroy_obsolete_records
      raise NotImplementedError
    end

    private def process_row(row, row_number)
      raise NotImplementedError
    end
  end
end
