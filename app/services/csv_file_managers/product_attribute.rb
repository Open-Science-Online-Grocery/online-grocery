# frozen_string_literal: true

module CsvFileManagers
  # responsible for generating and importing product attribute csv files
  class ProductAttribute < Base
    extend Memoist
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

    private def records_previously_loaded?
      @condition.custom_product_attributes.exists?(
        product_attribute_csv_file: current_file
      )
    end

    private def current_file
      @condition.current_product_attribute_csv_file
    end
    memoize :current_file

    private def destroy_obsolete_records
      @condition.custom_product_attributes.where.not(
        product_attribute_csv_file: current_file
      ).delete_all
    end

    private def process_row(row, row_number)
      attribute_amount = row[headers.last]
      return if attribute_amount.blank?
      product = find_product(row_number, row[headers.first])
      create_custom_product_attribute(product, attribute_amount)
    end

    private def find_product(row_number, id)
      product = Product.find_by(id: id)
      return product if product
      add_error(
        row_number,
        "Can't find product with Id #{id}"
      )
      nil
    end

    private def create_custom_product_attribute(product, attribute_amount)
      custom_product_attribute = @condition.custom_product_attributes
        .new(
          product_attribute_csv_file: current_file,
          product: product,
          custom_attribute_amount: attribute_amount
        )
      return if custom_product_attribute.save
      @errors += custom_product_attribute.errors.full_messages
    end
  end
end
