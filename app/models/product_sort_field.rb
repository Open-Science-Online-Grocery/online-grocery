# frozen_string_literal: true

# represents a field products may be sorted on in the grocery store
class ProductSortField < ApplicationRecord
  validates :name, :description, presence: true, uniqueness: true

  # we don't have every piece of nutrition data for every product. this method
  # indicates if the store contains any products missing data for this field
  def incomplete_data?
    return false unless name.to_sym.in?(Product.nutrition_fields)
    Product.where(name => nil).any?
  end
end
