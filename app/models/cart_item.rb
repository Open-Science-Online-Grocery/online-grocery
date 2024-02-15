# frozen_string_literal: true

# Represents cart items for temp cart, it contain product id and quantity
class CartItem < ApplicationRecord
  belongs_to :temp_cart
  belongs_to :product
end
