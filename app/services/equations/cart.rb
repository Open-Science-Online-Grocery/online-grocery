module Equations
  class Cart < Equation
    include Equations::EvaluatesCart

    private def should_return_boolean?
      true
    end
  end
end
