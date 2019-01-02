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

    private def prepare_cart_data(cart)
      variables.each_with_object({}) do |variable, data|
        data[variable] = cart.public_send(variable)
      end
    end

    private def evaluate_with_fake_data
      evaluate(fake_cart_data)
    end

    private def fake_cart_data
      self.class.cart_variables.keys
        .each_with_object(OpenStruct.new) do |colname, data|
          data[colname] = 1
          data
        end
    end

    private def should_return_boolean?
      true
    end
  end
end
