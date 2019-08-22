# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  include Rails.application.routes.url_helpers

  attr_writer :show_food_count, :active_tag_csv, :style_use_type

  validates :name, :uuid, :qualtrics_code, :sort_type, presence: true
  validates :name, uniqueness: { scope: :experiment_id }
  validate :unique_label_names

  delegate :sort_types, :style_use_types, :food_count_formats,
           to: :class
  delegate :name, to: :default_sort_field, prefix: true, allow_nil: true
  delegate :variables, to: :nutrition_equation, prefix: true
  delegate :variables, to: :sort_equation, prefix: true

  belongs_to :experiment
  belongs_to :default_sort_field, optional: true, class_name: 'ProductSortField'
  has_many :condition_product_sort_fields, dependent: :destroy
  has_many :product_sort_fields, through: :condition_product_sort_fields
  has_many :tag_csv_files, dependent: :destroy
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags
  has_many :subtags, through: :product_tags
  has_many :condition_cart_summary_labels, dependent: :destroy
  has_many :cart_summary_labels, through: :condition_cart_summary_labels
  has_many :condition_labels, dependent: :destroy
  has_many :labels, through: :condition_labels

  accepts_nested_attributes_for :product_sort_fields
  accepts_nested_attributes_for :condition_cart_summary_labels,
                                :condition_labels,
                                :tag_csv_files,
                                allow_destroy: true

  def self.sort_types
    OpenStruct.new(
      none: 'none',
      field: 'field',
      calculation: 'calculation',
      random: 'random'
    )
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

  def style_use_type
    return @style_use_type if @style_use_type
    return style_use_types.calculation if nutrition_equation_tokens
    style_use_types.always
  end

  def style_uses_calculation?
    style_use_type == Condition.style_use_types.calculation
  end

  def sort_equation
    @sort_equation ||= Equation.for_type(
      Equation.types.sort,
      sort_equation_tokens
    )
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
      Equation.types.nutrition,
      nutrition_equation_tokens
    )
  end

  def ratio_count?
    food_count_format == food_count_formats.ratio
  end

  def unique_label_names
    # The names of all the non-destroyed labels, this allows deletion of
    # a label with a conflicting name
    label_names = condition_labels
      .reject(&:marked_for_destruction?)
      .map(&:label)
      .map(&:name)

    duplicate_names = label_names.select.with_index do |name, index|
      label_names.index(name) != index
    end

    duplicate_names.uniq.each do |dup_name|
      errors.add(:base, "Label name '#{dup_name}' is already in use.")
    end
  end
end
