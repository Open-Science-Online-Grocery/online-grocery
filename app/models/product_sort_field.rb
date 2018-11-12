# frozen_string_literal: true

# represents a field products may be sorted on in the grocery store
class ProductSortField < ApplicationRecord
  validates :name, :description, presence: true, uniqueness: true
end
