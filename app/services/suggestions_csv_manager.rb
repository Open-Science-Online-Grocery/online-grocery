# frozen_string_literal: true

# responsible for generating and importing suggestion csv files
class SuggestionsCsvManager
  attr_reader :errors

  delegate :headers, to: :class

  def self.headers
    [
      'Product Id',
      'Product Name',
      'Add-on Id'
    ]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << headers

      Product.find_each do |product|
        csv << [product.id, product.name, '']
      end
    end
  end

  # @param condition [Condition] the condition to import suggestions for
  def initialize(condition)
    @condition = condition
    @current_file = @condition.current_suggestion_csv_file
    @errors = []
  end

  def import
    destroy_obsolete_suggestions
    return true if suggestions_previously_loaded?
    validate_file_type
    import_new_suggestions if @errors.none?
    @errors.none?
  end

  private def destroy_obsolete_suggestions
    @condition.product_suggestions.where.not(
      suggestion_csv_file: @current_file
    ).destroy_all
  end

  private def suggestions_previously_loaded?
    @condition.product_suggestions.where(
      suggestion_csv_file: @current_file
    ).exists?
  end

  private def validate_file_type
    extension = File.extname(@current_file.path)
    @errors << 'The uploaded file must be a CSV' unless extension == '.csv'
  end

  private def import_new_suggestions
    CSV.foreach(@file.path, headers: true).with_index do |row, row_number|
      process_row(row, row_number)
    end
  end

  private def process_row(row, row_number)
    product = find_product(headers.first)
    add_on = find_product(headers.last, add_on: true)
    create_product_suggestion(product, add_on) if product && add_on
  end

  private def find_product(row_number, id, add_on: false)
    return if add_on && id.blank? # we don't require an add-on for every row
    product = Product.find_by(id: id)
    return product if product
    @errors << "Row #{row_number}: Can't find #{add_on ? 'add-on' : 'product'}"/
      " with Id #{id}"
    nil
  end

  private def create_product_suggestion(product, add_on)
    product_suggestion = @condition.product_suggestions.build(
      suggestion_csv_file: @current_file,
      product: product,
      add_on: add_on
    )
    return if product_suggestion.save
    @errors += product_suggestion.errors.full_messages
  end
end
