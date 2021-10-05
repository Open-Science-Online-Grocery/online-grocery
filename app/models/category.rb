# frozen_string_literal: true

# represents a category a product may belong to
class Category < ApplicationRecord
  has_many :subcategories,
           -> { sorted },
           dependent: false,
           inverse_of: :category

  alias_attribute :to_s, :name

  scope :sorted, -> { order(:id) }
end
