# frozen_string_literal: true

# responsible for evaluating equations that users specify using
# the `calculator` React widget
class Equation
  include ActiveModel::Model

  validate :parses_correctly, :returns_expected_type

  def self.individual_product_variables
    {
      caloriesFromFat: 'Calories from fat per serving',
      calories: 'Calories per serving',
      totalFat: 'Total fat per serving (g)',
      saturatedFat: 'Saturated fat per serving (g)',
      transFat: 'Trans fat per serving (g)',
      cholesterol: 'Cholesterol per serving (mg)',
      sodium: 'Sodium per serving (mg)',
      carbs: 'Total carbohydrates per serving (g)',
      fiber: 'Dietary fiber per serving (g)',
      sugar: 'Sugars per serving (g)',
      protein: 'Protein per serving (g)',
      price: 'Price',
      starpoints: 'Star points'
    }
  end

  # @param [string] token_string - a JSON-ified string representing an array of
  #   token hashes as output by the React `calculator` widget. Before JSON
  #   serializing, it should look like this:
  #     [
  #       { id: <some uuid>, type: 'variable', value: 'calories' },
  #       { id: <some uuid>, type: 'operator', value: '>' },
  #       { id: <some uuid>, type: 'digit', value: '2' }
  #     ]
  #   note: `id` is not strictly needed here and is only used by the React code
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
      'label' => true,
      'sort' => false
    }[@type]
  end

  # here we test the equation by evaluating it against fake food attributes
  # checking that it returns the right kind of value.
  private def test_value
    @test_value ||= calculator.evaluate(to_s, fake_product_data)
  end

  private def fake_product_data
    self.class.individual_product_variables.keys
      .each_with_object({}) do |colname, data|
        data[colname] = 1
        data
      end
  end

  # Dentaku is a parser and evaluator for a mathematical and logical formula
  # language that allows run-time binding of values to variables referenced in
  # the formulas. It is intended to safely evaluate untrusted expressions
  # without opening security holes.
  #
  # Basic usage:
  #   calculator = Dentaku::Calculator.new
  #   calculator.evaluate('10 * 2')
  #
  # Usage with runtime-defined variables:
  #   calculator.evaluate('kiwi + 5', kiwi: 2)
  private def calculator
    @calculator ||= Dentaku::Calculator.new
  end

  private def returns_boolean?
    [true, false].include?(test_value)
  end

  private def parses_correctly
    # the dentaku gem returns nil if there are any errors in the equation
    return unless test_value.nil?
    errors.add(
      :base,
      'This calculation has an error. Please change the calculation and try '\
      'again.'
    )
  end

  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  private def returns_expected_type
    return if test_value.nil?
    if should_return_boolean? && !returns_boolean?
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
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end
