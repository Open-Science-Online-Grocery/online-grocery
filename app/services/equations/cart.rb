# frozen_string_literal: true

module Equations
  # represents an equation that determines whether an image should be shown
  # on the checkout page for a given cart
  class Cart < Equation
    include Equations::EvaluatesCart

    private def should_return_boolean?
      true
    end
  end
end
