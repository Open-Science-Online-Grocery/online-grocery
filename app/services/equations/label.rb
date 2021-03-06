# frozen_string_literal: true

module Equations
  # represents an equation that determines whether a label should be shown on
  # a product
  class Label < Equation
    include Equations::EvaluatesProduct

    private def should_return_boolean?
      true
    end
  end
end
