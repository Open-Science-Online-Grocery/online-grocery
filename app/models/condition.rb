# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  include Rails.application.routes.url_helpers

  attr_writer :show_food_count, :style_use_type, :included_category_ids,
              :included_subcategory_ids

  validates :name, :uuid, :qualtrics_code, :sort_type, presence: true
  validates :name, uniqueness: { scope: :experiment_id }
  validate :sort_file_present_if_needed
  validate :unique_label_names

  delegate :sort_types, :style_use_types, :food_count_formats,
           to: :class
  delegate :name, to: :default_sort_field, prefix: true, allow_nil: true
  delegate :variables, to: :nutrition_equation, prefix: true
  delegate :variables, to: :sort_equation, prefix: true

  belongs_to :experiment
  belongs_to :default_sort_field, optional: true, class_name: 'ProductSortField'

  # CAUTION: for some of these relations we are using `dependent: :delete_all`.
  # this is because a condition may have a large number (hundreds of thousands)
  # of such records and `dependent: :destroy` will instantiate each child record
  # in memory before deleting it in order to run its deletion callbacks if
  # present. we are using `:delete_all` to avoid this, but this means any
  # deletion callbacks on those associated records won't be run. these classes
  # don't currently use deletion callbacks, but be wary of changing other
  # relations to use `dependent: :delete_all`.
  has_many :condition_product_sort_fields, dependent: :destroy
  has_many :product_sort_fields, through: :condition_product_sort_fields
  has_many :tag_csv_files, dependent: :destroy
  has_many :suggestion_csv_files, dependent: :destroy
  has_many :product_attribute_csv_files, dependent: :destroy
  has_many :product_price_csv_files, dependent: :destroy
  has_many :custom_product_prices, dependent: :delete_all
  has_many :sort_files, dependent: :destroy
  has_many :product_tags, dependent: :delete_all
  has_many :tags, through: :product_tags
  has_many :subtags, through: :product_tags
  has_many :product_suggestions, dependent: :delete_all
  has_many :custom_product_attributes, dependent: :delete_all
  has_many :condition_cart_summary_labels, dependent: :destroy
  has_many :cart_summary_labels, through: :condition_cart_summary_labels
  has_many :condition_labels, dependent: :destroy
  has_many :labels, through: :condition_labels
  has_many :subcategory_exclusions, dependent: :destroy
  has_many :excluded_subcategories,
           through: :subcategory_exclusions,
           source: :subcategory
  has_many :custom_sortings, dependent: :delete_all

  accepts_nested_attributes_for :product_sort_fields
  accepts_nested_attributes_for :condition_cart_summary_labels,
                                :condition_labels,
                                :tag_csv_files,
                                :suggestion_csv_files,
                                :sort_files,
                                allow_destroy: true

  def self.sort_types
    OpenStruct.new(
      none: 'none',
      field: 'field',
      calculation: 'calculation',
      random: 'random',
      file: 'file'
    )
  end

  def self.style_use_types
    OpenStruct.new(always: 'always', calculation: 'calculation')
  end

  def self.food_count_formats
    OpenStruct.new(ratio: 'ratio', percent: 'percent')
  end

  def uses_custom_attributes?
    product_attribute_csv_files.active.exists?
  end

  def uses_custom_prices?
    product_price_csv_files.active.exists?
  end

  def products
    Product.where.not(subcategory_id: excluded_subcategory_ids)
  end

  def new_tag_csv_file=(value)
    return unless value
    tag_csv_files.each { |t| t.active = false }
    tag_csv_files.build(file: value)
  end

  def current_tag_csv_file
    tag_csv_files.select { |f| f.active? && f.persisted? }.max_by(&:created_at)
  end

  def new_suggestion_csv_file=(value)
    return unless value
    suggestion_csv_files.each { |s| s.active = false }
    suggestion_csv_files.build(file: value)
  end

  def current_suggestion_csv_file
    suggestion_csv_files
      .select { |f| f.active? && f.persisted? }
      .max_by(&:created_at)
  end

  def current_product_attribute_csv_file
    product_attribute_csv_files.select { |f| f.active? && f.persisted? }
      .max_by(&:created_at)
  end

  def new_current_product_attribute_file=(value)
    return unless value
    product_attribute_csv_files.each { |s| s.active = false }
    product_attribute_csv_files.build(file: value)
  end

  def current_product_price_csv_file
    product_price_csv_files.select { |f| f.active? && f.persisted? }
      .max_by(&:created_at)
  end

  def new_product_price_file=(value)
    return unless value
    product_price_csv_files.each { |s| s.active = false }
    product_price_csv_files.build(file: value)
  end

  def new_sort_file=(value)
    return unless value
    sort_files.each { |s| s.active = false }
    sort_files.build(file: value)
  end

  # the `active_was` here checks for files that have been marked inactive but
  # not yet saved.  this allows the unchecked checkbox to remain in the form
  # so that data can be saved on submit.
  def current_sort_file
    sort_files
      .select { |f| (f.active? || f.active_was) && f.persisted? }
      .max_by(&:created_at)
  end

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
      sort_equation_tokens,
      self
    )
  end

  def show_food_count
    return food_count_format.present? if @show_food_count.nil?
    @show_food_count
  end

  def nutrition_equation
    @nutrition_equation ||= Equation.for_type(
      Equation.types.nutrition,
      nutrition_equation_tokens,
      self
    )
  end

  def ratio_count?
    food_count_format == food_count_formats.ratio
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def included_subcategories
    Subcategory.sorted.where.not(id: excluded_subcategory_ids)
  end

  # rubocop:disable Rails/UniqBeforePluck
  def included_category_ids
    @included_category_ids&.map(&:to_i) ||
      included_subcategories.pluck(:category_id).uniq
  end
  # rubocop:enable Rails/UniqBeforePluck

  def included_subcategory_ids
    @included_subcategory_ids&.map(&:to_i) || included_subcategories.pluck(:id)
  end

  private def sort_file_present_if_needed
    return if sort_type != sort_types.file || sort_files.select(&:active?).any?
    errors.add(
      :base,
      'Please upload a custom sort file or choose a different sort type'
    )
  end
end
