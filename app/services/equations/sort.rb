# frozen_string_literal: true

module Equations
  # represents an equation that determines how to sort products
  class Sort < Equation
    include Equations::EvaluatesProduct

    def variables
      ProductVariable.all(@condition)
    end

    private def should_return_boolean?
      false
    end
  end
end
