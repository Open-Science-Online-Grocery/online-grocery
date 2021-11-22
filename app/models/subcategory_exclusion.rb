# frozen_string_literal: true

# represents a subcategory that should NOT be shown for a given condition
class SubcategoryExclusion < ApplicationRecord
  belongs_to :subcategory
  belongs_to :condition
end
