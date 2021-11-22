# frozen_string_literal: true

module CsvFileManagers
  # responsible for generating and importing suggestion csv files
  class Suggestion < Base
    extend Memoist

    def self.headers
      [
        'Product Id',
        'Product Name',
        'Add-on Id'
      ]
    end

    def self.product_row(product)
      [product.id, product.name, '']
    end

    private def records_previously_loaded?
      @condition.product_suggestions.exists?(suggestion_csv_file: current_file)
    end

    private def current_file
      @condition.current_suggestion_csv_file
    end
    memoize :current_file

    private def destroy_obsolete_records
      @condition.product_suggestions.where.not(
        suggestion_csv_file: current_file
      ).destroy_all
    end

    private def process_row(row, row_number)
      add_on = find_product(row_number, row[headers.last], add_on: true)
      return unless add_on
      product = find_product(row_number, row[headers.first])
      create_product_suggestion(product, add_on) if product && add_on
    end

    private def find_product(row_number, id, add_on: false)
      return if add_on && id.blank? # we don't require an add-on for every row
      product = Product.find_by(id: id)
      return product if product
      add_error(
        row_number,
        "Can't find #{add_on ? 'add-on' : 'product'} with Id #{id}"
      )
      nil
    end

    private def create_product_suggestion(product, add_on)
      product_suggestion = @condition.product_suggestions.build(
        suggestion_csv_file: current_file,
        product: product,
        add_on_product: add_on
      )
      return if product_suggestion.save
      @errors += product_suggestion.errors.full_messages
    end
  end
end
