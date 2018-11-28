# frozen_string_literal: true

module Equations
  # contains functionality for Equations that evaluate a whole cart at once
  module EvaluatesCart
    def evaluate(cart_data)
      return nil if @tokens.none?
      calculator.evaluate(to_s, cart_data)
    end

    def prepare_cart_data(cart)
      variables.each_with_object({}) do |variable, data|
        data[variable] = cart.public_send(variable)
      end
    end

    private def evaluate_with_fake_data
      evaluate(fake_cart_data)
    end

    private def fake_cart_data
      self.class.cart_variables.keys
        .each_with_object({}) do |colname, data|
          data[colname] = 1
          data
        end
    end
  end
end
