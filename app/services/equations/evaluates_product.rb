# frozen_string_literal: true

module Equations
  # contains functionality for Equations that evaluate a single product
  module EvaluatesProduct
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
        value = evaluator.get_value(variable_token)
        new_hash[variable_token] = value.is_a?(String) ? value.to_f : value
        new_hash
      end
    end

    private def evaluate_with_fake_data
      evaluate(fake_product_data)
    end

    private def fake_product_data
      ProductVariable.all(@condition).compact.map(&:attribute)
        .each_with_object({}) do |colname, data|
          data[colname] = 1
          data
        end
    end
  end
end
