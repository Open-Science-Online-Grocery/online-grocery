# frozen_string_literal: true

# represents a product in a grocery store
class Product < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory
  belongs_to :subsubcategory, optional: true

  has_many :product_tags, dependent: :destroy
  has_many :product_suggestions, dependent: :destroy
  has_many :custom_sortings, dependent: :destroy
  has_many :custom_product_attributes, dependent: :destroy

  scope :name_matches, ->(string) {
    where(arel_table[:name].matches("%#{string}%"))
  }

  scope :with_tag, ->(tag_id) {
    joins(:product_tags).where(product_tags: { tag_id: tag_id })
  }

  scope :with_subtag, ->(subtag_id) {
    joins(:product_tags).where(product_tags: { subtag_id: subtag_id })
  }

  def self.nutrition_fields
    ProductVariable.nutrition.map(&:attribute)
  end

  def add_on_product(condition)
    product_suggestions.find do |suggestion|
      suggestion.condition_id == condition.id
    end.try(:add_on_product)
  end

  def custom_attribute_amount(condition)
    return unless custom_product_attributes
    custom_product_attributes
      .find_by(condition: condition)
      .custom_attribute_amount
  end
end
