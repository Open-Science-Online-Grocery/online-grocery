# frozen_string_literal: true

module Equations
  # represents an equation that determines how to sort products
  class Sort < Equation
    include Equations::EvaluatesProduct

    private def should_return_boolean?
      false
    end
  end
end
