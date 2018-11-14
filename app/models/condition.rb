# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  include Rails.application.routes.url_helpers

  attr_writer :label_type, :sort_type, :style_use_type

  validates :name, :uuid, presence: true
  validates :name, uniqueness: { scope: :experiment_id }

  delegate :label_types, :sort_types, :style_use_types, to: :class
  delegate :image_url, to: :label, prefix: true, allow_nil: true
  delegate :name, to: :default_sort_field, prefix: true, allow_nil: true

  belongs_to :experiment
  belongs_to :label, optional: true
  belongs_to :default_sort_field, optional: true, class_name: 'ProductSortField'
  has_many :condition_product_sort_fields, dependent: :destroy
  has_many :product_sort_fields, through: :condition_product_sort_fields

  accepts_nested_attributes_for :label, :product_sort_fields

  def self.label_types
    OpenStruct.new(none: 'none', provided: 'provided', custom: 'custom')
  end

  def self.sort_types
    OpenStruct.new(none: 'none', field: 'field', calculation: 'calculation')
  end

  def self.style_use_types
    OpenStruct.new(always: 'always', calculation: 'calculation')
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
    @label_equation ||= Equation.new(
      label_equation_tokens,
      Equation.types.label
    )
  end

  def has_label_equation?
    label_equation_tokens.present?
  end

  def sort_equation
    @sort_equation ||= Equation.new(sort_equation_tokens, Equation.types.sort)
  end
end
