# frozen_string_literal: true

module Equations
  # represents an equation that determines which products to show custom
  # nutrition label styling on
  class Nutrition < Equation
    include Equations::EvaluatesProduct

    def variables
      ProductVariable.all(@condition)
    end

    private def should_return_boolean?
      true
    end
  end
end
