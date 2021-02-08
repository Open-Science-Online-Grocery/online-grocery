# frozen_string_literal: true

# join model connecting products to their suggested add-on product
class ProductSuggestion < ApplicationRecord
  validates :product_id, uniqueness: { scope: :condition_id }

  belongs_to :condition
  belongs_to :product
  belongs_to :add_on_product, class_name: 'Product'
  belongs_to :suggestion_csv_file
end
