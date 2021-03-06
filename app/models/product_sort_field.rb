# frozen_string_literal: true

# represents a field products may be sorted on in the grocery store
class ProductSortField < ApplicationRecord
  validates :name, :description, presence: true, uniqueness: true

  def to_s
    description
  end

  # we don't have every piece of data for every product. this method indicates
  # whether the store contains any products missing data for this field
  def incomplete_data?
    variable = ProductVariable.from_attribute(name)
    return false unless variable
    variable.incomplete_data?
  end
end
