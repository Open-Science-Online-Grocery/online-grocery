module Equations
  module EvaluatesCart
    def evaluate(cart_attributes)
      return nil if @tokens.none?
      calculator.evaluate(to_s, cart_attributes)
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
