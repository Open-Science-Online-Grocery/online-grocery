# frozen_string_literal: true

# represents a category a product may belong to
class Category < ApplicationRecord
  has_many :subcategories, dependent: false
end
