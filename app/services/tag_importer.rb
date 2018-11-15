# frozen_string_literal: true

# responsible for all data manipulation required for
# importing custom categories (tags)
class TagImporter
  require 'csv'

  attr_reader :errors

  def initialize(file:, condition:)
    @file = file
    @condition = condition.condition
    @errors = []
    @required_attributes = ProductDataCsvManager
      .built_in_category_attributes
      .values
    @custom_category_attributes = ProductDataCsvManager
      .custom_category_attributes
      .values
  end

  def import
    validate_file_type
    create_data_from_import if @errors.blank?
    @errors.blank?
  end

  private def validate_file_type
    extension = File.extname(@file.path)
    @errors << 'The uploaded file must be a CSV' unless extension == '.csv'
  end

  private def create_data_from_import
    # requires_new: true is used to allow this class to be used within
    # another transaction and still persist rollbacks.
    # see https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html
    ActiveRecord::Base.transaction(requires_new: true) do
      CSV.foreach(
        @file.path,
        headers: true,
        converters: :all,
        header_converters: convert_header_lambda
      ).with_index do |row, row_number|
        row_data = row.to_h.with_indifferent_access
        validate_row(row_data, row_number)
        create_tags(row_data, row_number)
      end
      raise ActiveRecord::Rollback if @errors.any?
    end
  end

  # lambda to convert displayed headers to symbol attribute names
  private def convert_header_lambda
    ->(header) { ProductDataCsvManager.product_data_csv_attributes[header] }
  end

  private def validate_row(row_data, row_number)
    @required_attributes.each do |attribute|
      require_attribute(attribute, row_data[attribute], row_number)
    end
    validate_tags(row_data, row_number)
  end

  private def validate_tags(row_data, row_number)
    @custom_category_attributes.each_slice(2) do |category, subcategory|
      break if @errors.any?
      tag_name = row_data[category]
      subtag_name = row_data[subcategory]

      require_attribute(category, tag_name, row_number) if subtag_name.present?
    end
  end

  private def create_tags(row_data, row_number)
    @custom_category_attributes.each_slice(2) do |category, subcategory|
      break if @errors.any?
      tag_name = row_data[category]
      subtag_name = row_data[subcategory]
      product_id = row_data[:product_id]

      create_single_tag(tag_name, subtag_name, product_id, row_number)
    end
  end

  private def create_single_tag(tag_name, subtag_name, product_id, row_number)
    return unless tag_name.present? && product_id.present?
    begin
      create_product_tag(
        product_id: product_id,
        tag_name: tag_name,
        subtag_name: subtag_name
      )
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => error
      standard_error(error.message, row_number)
    end
  end

  private def create_product_tag(product_id:, tag_name:, subtag_name:)
    product = Product.find(product_id)
    tag = Tag.find_or_create_by!(name: tag_name)
    subtag = Subtag.find_or_create_by!(name: subtag_name, tag: tag)
    return unless product.present? && tag.present?
    @condition.product_tags.create!(
      product: product,
      tag: tag,
      subtag: subtag
    )
  end

  private def require_attribute(attr, value, row_number)
    missing_required_attribute_error(attr, row_number) unless value.present?
  end

  private def missing_required_attribute_error(attr, row_number)
    @errors << "Row #{row_number + 1}: "\
      "#{attr.to_s.humanize.titleize} is required"
  end

  private def standard_error(error_message, row_number)
    @errors << "Row #{row_number + 1}: #{error_message}"
  end
end
