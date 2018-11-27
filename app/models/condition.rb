# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  include Rails.application.routes.url_helpers

  attr_writer :label_type, :show_food_count, :sort_type, :active_tag_csv,
              :style_use_type

  validates :name, :uuid, presence: true
  validates :name, uniqueness: { scope: :experiment_id }

  delegate :label_types, :sort_types, :style_use_types, :food_count_formats,
           to: :class
  delegate :image_url, :name, to: :label, prefix: true, allow_nil: true
  delegate :name, to: :default_sort_field, prefix: true, allow_nil: true

  belongs_to :experiment
  belongs_to :label, optional: true
  belongs_to :default_sort_field, optional: true, class_name: 'ProductSortField'
  has_many :condition_product_sort_fields, dependent: :destroy
  has_many :product_sort_fields, through: :condition_product_sort_fields
  has_many :tag_csv_files, dependent: :destroy
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags
  has_many :subtags, through: :product_tags
  has_many :condition_cart_summary_labels, dependent: :destroy
  has_many :cart_summary_labels, through: :condition_cart_summary_labels

  accepts_nested_attributes_for :label, :product_sort_fields
  accepts_nested_attributes_for :condition_cart_summary_labels,
                                :tag_csv_files,
                                allow_destroy: true

  def self.label_types
    OpenStruct.new(none: 'none', provided: 'provided', custom: 'custom')
  end

  def self.sort_types
    OpenStruct.new(none: 'none', field: 'field', calculation: 'calculation')
  end

  def self.style_use_types
    OpenStruct.new(always: 'always', calculation: 'calculation')
  end

  def self.food_count_formats
    OpenStruct.new(ratio: 'ratio', percent: 'percent')
  end

  # TODO: update if needed - depending on client's preferences on URL used to
  # access the store
  def url
    store_url(condId: uuid)
  end

  def label_type
    return @label_type if @label_type
    return label_types.none if label.nil?
    label.built_in? ? label_types.provided : label_types.custom
  end

  def sort_type
    return @sort_type if @sort_type
    return sort_types.field if default_sort_field
    return sort_types.calculation if sort_equation_tokens
    sort_types.none
  end

  def style_use_type
    return @style_use_type if @style_use_type
    return style_use_types.calculation if nutrition_equation_tokens
    style_use_types.always
  end

  def label_equation
    @label_equation ||= Equation.for_type(
      label_equation_tokens,
      Equation.types.label
    )
  end

  def sort_equation
    @sort_equation ||= Equation.for_type(sort_equation_tokens, Equation.types.sort)
  end

  def current_tag_csv_file
    tag_csv_files
      .order(created_at: :desc)
      .select(&:active)
      .first
  end

  def historical_tag_csv_files
    tag_csv_files
      .order(created_at: :desc)
      .reject(&:active)
  end

  def show_food_count
    return food_count_format.present? if @show_food_count.nil?
    @show_food_count
  end

  def active_tag_csv
    return @active_tag_csv unless @active_tag_csv.nil?
    current_tag_csv_file.present?
  end

  def nutrition_equation
    @nutrition_equation ||= Equation.for_type(
      nutrition_equation_tokens,
      Equation.types.nutrition
    )
  end

  def ratio_count?
    food_count_format == food_count_formats.ratio
  end
end
