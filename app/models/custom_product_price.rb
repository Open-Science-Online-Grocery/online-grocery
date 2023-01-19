# frozen_string_literal: true

# join model connecting products to a possible custom price
class CustomProductPrice < ApplicationRecord
  validates :product_id, uniqueness: { scope: :condition_id }

  belongs_to :condition
  belongs_to :product
  belongs_to :product_price_csv_file
end
