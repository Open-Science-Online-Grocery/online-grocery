# frozen_string_literal: true

module Equations
  # contains functionality for Equations that evaluate a single product
  module EvaluatesProduct
    def evaluate(product_attributes)
      return nil if @tokens.none?
      calculator.evaluate(to_s, product_attributes)
    end

    def variables
      ProductVariable.all
    end

    private def evaluate_with_fake_data
      evaluate(fake_product_data)
    end

    private def fake_product_data
      ProductVariable.all.map(&:attribute)
        .each_with_object({}) do |colname, data|
          data[colname] = 1
          data
        end
    end
  end
end
