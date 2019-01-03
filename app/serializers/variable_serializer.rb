# frozen_string_literal: true

class VariableSerializer
  def initialize(variables)
    @variables = variables
  end

  def serialize
    @variables.map do |variable|
      {
        token: variable.token_name,
        description: variable.description,
        incomplete_data: variable.incomplete_data?
      }
    end.to_json
  end
end
