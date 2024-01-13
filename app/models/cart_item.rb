class CartItem < ApplicationRecord
  belongs_to :temp_cart
  belongs_to :product
end
