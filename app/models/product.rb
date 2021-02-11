# frozen_string_literal: true

# represents a product in a grocery store
class Product < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory
  belongs_to :subsubcategory, optional: true

  has_many :product_tags, dependent: :destroy
  has_one :product_suggestion, dependent: :destroy
  has_one :add_on_product, through: :product_suggestion

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
end
