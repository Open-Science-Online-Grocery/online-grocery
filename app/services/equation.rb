# frozen_string_literal: true

class Equation
  include ActiveModel::Model

  validate :returns_expected_type

  # @param [string] token_string - a JSON-ified string representing an array of
  #   token hashes as output by the React `calculator` widget. Before JSON
  #   serializing, it should look like this:
  #     [
  #       { id: <some uuid>, type: 'variable', value: 'calories' },
  #       { id: <some uuid>, type: 'operator', value: '>' },
  #       { id: <some uuid>, type: 'digit', value: '2' }
  #     ]
  def initialize(token_string, type)
    @tokens = JSON.parse(token_string).map(&:with_indifferent_access)
    @type = type
  end

  def to_s
    str = @tokens.first[:value]
    last_token = @tokens.first
    @tokens.from(1).each do |token|
      if last_token[:type] == 'digit' && token[:type] == 'digit'
        str += token[:value]
      else
        str += " #{token[:value]}"
      end
      last_token = token
    end
    str
  end

  private def should_return_boolean?
    {
      'label' => true
    }[@type]
  end

  # here we test the equation by evaluating it against a random food and
  # checking that it returns the right kind of value.
  #
  # TODO: currently, cholesterol is nil for many foods. need to set a default
  # value in the db or
  private def test_value
    @test_value ||= calculator.evaluate(
      to_s,
      { cholesterol: 0 }.merge(Product.first.attributes)
    )
  end

  private def calculator
    @calculator ||= Dentaku::Calculator.new
  end

  private def returns_boolean?
    [true, false].include?(test_value)
  end

  private def returns_expected_type
    if test_value.nil?
      errors.add(
        :base,
        'This calculation has an error. Please change the calculation and try '\
        'again.'
      )
    elsif should_return_boolean? && !returns_boolean?
      errors.add(
        :base,
        'This equation returns a number but should return TRUE or FALSE instead'
      )
    elsif returns_boolean? && !should_return_boolean?
      errors.add(
        :base,
        'This equation returns TRUE/FALSE but should return a number instead'
      )
    end
  end
end
