# frozen_string_literal: true

module Equations
  # represents an equation that determines which products to show custom
  # nutrition label styling on
  class Nutrition < Equation
    def variables
      ProductVariable.all(@condition)
    end

    def evaluate(product_attributes)
      return nil if @tokens.none?
      product_data = prepare_product_data(product_attributes)
      calculator.evaluate(to_s, product_data)
    end

    private def prepare_product_data(product_attributes)
      evaluator = ProductEvaluator.new(@condition, product_attributes)
      variable_tokens.each_with_object({}) do |variable_token, new_hash|
        new_hash[variable_token] = evaluator.get_value(variable_token).to_f
        new_hash
      end
    end

    private def should_return_boolean?
      false
    end

    private def evaluate_with_fake_data
      evaluate(fake_product_data)
    end

    private def fake_product_data
      ProductVariable.all(@condition).map(&:attribute)
        .each_with_object({}) do |colname, data|
          data[colname] = 1
          data
        end
    end
  end
end
