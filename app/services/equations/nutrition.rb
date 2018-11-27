module Equations
  class Nutrition < Equation
    include Equations::EvaluatesProduct

    private def should_return_boolean?
      true
    end
  end
end
