# frozen_string_literal: true

module CsvFileManagers
  # responsible for generating and importing custom product price csv files
  class ProductPrice < Base
    extend Memoist
    def self.headers
      [
        'Product Id',
        'Product Name',
        'Current Price',
        'New Price'
      ]
    end

    def self.product_row(product)
      [product.id, product.name, product.price, '']
    end

    private def records_previously_loaded?
      @condition.custom_product_prices.exists?(
        product_price_csv_file: current_file
      )
    end

    private def current_file
      @condition.current_product_price_csv_file
    end
    memoize :current_file

    private def destroy_obsolete_records
      @condition.custom_product_prices.where.not(
        product_price_csv_file: current_file
      ).delete_all
    end

    private def process_row(row, row_number)
      return unless row_is_valid?(row, row_number)
      attribute_amount = row[headers.last]
      return if attribute_amount.blank?
      product = find_product(row_number, row[headers.first])
      return if product.blank?
      create_custom_product_price(product, attribute_amount)
    end

    private def row_is_valid?(row, row_number)
      headers.each do |header|
        if row[header].blank? && header != headers.last
          add_error(row_number, "#{header} must have a value")
          return false
        end
      end
      true
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

    private def create_custom_product_price(product, attribute_amount)
      custom_product_price = @condition.custom_product_prices
        .new(
          product_price_csv_file: current_file,
          product: product,
          new_price: attribute_amount
        )
      return if custom_product_price.save
      @errors += custom_product_price.errors.full_messages
    end
  end
end
