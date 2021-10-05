# frozen_string_literal: true

# represents a subcategory a product may belong to
class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :subsubcategories, dependent: false

  alias_attribute :to_s, :name

  scope :sorted, -> { order(:category_id, :display_order) }
end
