# frozen_string_literal: true

# represents a product in a grocery store
class Product < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory
  has_many :product_tags, dependent: :destroy

  scope :name_matches, ->(string) {
    where(arel_table[:name].matches("%#{string}%"))
  }

  scope :with_tag, ->(tag_id) {
    joins(:product_tags).where(product_tags: { tag_id: tag_id })
  }

  scope :with_subtag, ->(subtag_id) {
    joins(:product_tags).where(product_tags: { subtag_id: subtag_id })
  }
end
