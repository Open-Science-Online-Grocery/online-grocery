# frozen_string_literal: true

# responsible for all data manipulation required for importing custom categories (tags)
class TagImporter
  require 'csv'

  attr_reader :errors

  # TODO: Create and translate from displayed csv headers to code headers
  def initialize(file)
    @file = file
    @errors = []
    @required_attributes = %i(product_name category subcategory)
    # the order of these 2 sets of attributes will determine pairings
    @tag_attributes = %i(custom_category1)
    @subtag_attributes = %i(custom_subcategory1)
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
      CSV.foreach(@file.path, headers: true).with_index do |row, row_number|
        row_data = row.to_h.with_indifferent_access
        validate_row(row_data, row_number)
        create_tags(row_data, row_number)
      end
      raise ActiveRecord::Rollback if @errors.any?
    end
  end

  private def validate_row(row_data, row_number)
    @required_attributes.each do |attribute|
      require_attribute(attribute, row_data[attribute], row_number)
    end
    validate_tags
  end

  # TODO: Remove this validation if subtags are optional
  private def validate_tags(row_data, row_number)
    @tag_attributes.each_with_index do |tag, i|
      subtag = @subtag_attributes[i]
      tag_name = row_data[tag]
      subtag_name = row_data[subtag]

      require_attribute(tag, tag_name, row_number) if subtag_name.present?
    end
  end

  private def create_tags(row_data, row_number)
    @tag_attributes.each_with_index do |tag, i|
      subtag = @subtag_attributes[i]
      tag_name = row_data[tag]
      subtag_name = row_data[subtag]
      product_name = row_data[:product_name]

      create_single_tag(tag_name, subtag_name, product_name, row_number)
    end
  end

  private def create_single_tag(tag_name, subtag_name, product_name, row_number)
    product = Product.find_by(name: product_name)
    missing_product_error(product_name, row_number) unless product.present?

    begin
      tag = Tag.find_or_create_by!(name: tag_name)
      subtag = Subtag.find_or_create_by!(name: subtag_name, tag: tag)
      ProductTag.find_or_create_by!(
        product: product,
        tag: tag,
        subtag: subtag
        )
    rescue ActiveRecord::RecordNotFound => error
      @errors << error.message
    end
  end

  private def require_attribute(attribute, value, row_number)
    missing_required_attribute_error(attribute, row_number) unless value.present?
  end

  private def missing_required_attribute_error(attribute, row_number)
    @errors << "Row #{row_number}: #{attribute.humanize.titleize} is required"
  end

  private def missing_product_error(product_name, row_number)
    @errors << "Row #{row_number}: Product with name `#{product_name}` could not be found"
  end
end
