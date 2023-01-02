# frozen_string_literal: true

module CsvFileManagers
  # responsible for generating and importing product attribute csv files
  class ProductAttribute < Base
    def self.headers
      [
        'Product Id',
        'Product Name',
        'Custom attribute amount'
      ]
    end

    def self.product_row(product)
      [product.id, product.name, '']
    end

    def self.generate_csv(condition)
      product_scope = condition.products
      CSV.generate(headers: true) do |csv|
        # headers
        csv << headers

        product_scope.find_each do |product|
          csv << generate_csv_row(product)
        end
      end
    end

    def self.generate_csv_row(product)
      row = []

      row << product.id
      row << product.name
      row << ''

      row
    end
    private_class_method :generate_csv_row
  end
end
