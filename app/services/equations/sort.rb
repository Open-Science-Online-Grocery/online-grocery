module Equations
  class Sort < Equation
    include Equations::EvaluatesProduct

    private def should_return_boolean?
      false
    end
  end
end
