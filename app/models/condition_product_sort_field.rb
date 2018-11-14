# frozen_string_literal: true

# represents a field that *participants* are allowed to sort products by in
# the grocery store
class ConditionProductSortField < ApplicationRecord
  belongs_to :condition
  belongs_to :product_sort_field
end
