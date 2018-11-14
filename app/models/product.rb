# frozen_string_literal: true

# represents a product in a grocery store
class Product < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory

  scope :name_matches, ->(string) {
    where(arel_table[:name].matches("%#{string}%"))
  }
end
