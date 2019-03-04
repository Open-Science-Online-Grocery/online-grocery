# frozen_string_literal: true

module Equations
  # represents an equation that determines whether an image should be shown
  # on the checkout page for a given cart
  class Cart < Equation
    def evaluate(cart)
      return nil if @tokens.none?
      cart_data = prepare_cart_data(cart)
      calculator.evaluate(to_s, cart_data)
    end

    def variables
      CartVariable.all(@condition)
    end

    private def prepare_cart_data(cart)
      variable_tokens.each_with_object({}) do |variable_token, data|
        data[variable_token] = cart.get_value(variable_token)
        data
      end
    end

    private def evaluate_with_fake_data
      evaluate(::Cart.new([], @condition))
    end

    private def should_return_boolean?
      true
    end
  end
end
