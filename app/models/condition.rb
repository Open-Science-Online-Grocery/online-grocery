# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  include Rails.application.routes.url_helpers

  attr_writer :label_type, :sort_type

  validates :name, :uuid, presence: true
  validates :name, uniqueness: { scope: :experiment_id }

  belongs_to :experiment
  belongs_to :label, optional: true
  belongs_to :default_sort_field, optional: true, class_name: 'ProductSortField'
  has_many :condition_product_sort_fields, dependent: :destroy
  has_many :product_sort_fields, through: :condition_product_sort_fields

  accepts_nested_attributes_for :label, :product_sort_fields

  # TODO: update if needed
  def url
    store_url(condId: uuid)
  end

  def label_type
    return @label_type if @label_type
    return 'none' if label.nil?
    label.built_in? ? 'provided' : 'custom'
  end

  def sort_type
    return @sort_type if @sort_type
    return 'field' if default_sort_field
    return 'calculation' if sort_equation_tokens
    'none'
  end
end
