# frozen_string_literal: true

# represents a category a product may belong to
class Category < ApplicationRecord
  has_many :subcategories, dependent: false

  alias_attribute :to_s, :name
end
