# frozen_string_literal: true

# responsible for all data manipulation required for importing custom categories (tags)
class TagImporter
  require 'csv'

  attr_reader :errors

  def initialize(file: file, condition: condition)
    @file = file
    @condition = condition
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
    extension = File.extname(@file)
    @errors << 'The uploaded file must be a CSV' unless extension == '.csv'
  end

  private def create_data_from_import
    ActiveRecord::Base.transaction do
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

  # TODO: Remove this validation if subtags are optional
  private def validate_tags(row_data, row_number)
    @custom_category_attributes.each_slice(2) do |category, subcategory|
      tag_name = row_data[category]
      subtag_name = row_data[subcategory]

      require_attribute(category, tag_name, row_number) if subtag_name.present?
    end
  end

  private def create_tags(row_data, row_number)
    @custom_category_attributes.each_slice(2) do |category, subcategory|
      tag_name = row_data[category]
      subtag_name = row_data[subcategory]
      product_name = row_data[:product_name]

      create_single_tag(tag_name, subtag_name, product_name, row_number)
    end
  end

  private def create_single_tag(tag_name, subtag_name, product_name, row_number)
    # TODO: remove subtag from this list if it is not required
    return unless tag_name.present? && subtag_name.present? && product_name.present?
    begin
      product = Product.find_by!(name: product_name)
      tag = Tag.find_or_create_by!(name: tag_name)
      subtag = Subtag.find_or_create_by!(name: subtag_name, tag: tag)
      if product.present? && tag.present?
        ProductTag.find_or_create_by!(
          product: product,
          tag: tag,
          subtag: subtag,
          condition: @condition,
          active: true
        )
      end
    rescue ActiveRecord::RecordNotFound => error
      record_not_found_error(error.message, row_number)
    end
  end

  private def require_attribute(attribute, value, row_number)
    missing_required_attribute_error(attribute, row_number) unless value.present?
  end

  private def missing_required_attribute_error(attribute, row_number)
    @errors << "Row #{row_number + 1}: #{attribute.to_s.humanize.titleize} is required"
  end

  private def record_not_found_error(error_message, row_number)
    @errors << "Row #{row_number + 1}: #{error_message}"
  end
end
