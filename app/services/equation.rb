# frozen_string_literal: true

# responsible for evaluating equations that users specify using
# the `calculator` React widget
class Equation
  include ActiveModel::Model

  validate :parses_correctly, :returns_expected_type

  delegate :types, to: :class

  def self.types
    OpenStruct.new(
      label: 'label',
      sort: 'sort',
      nutrition: 'nutrition',
      cart: 'cart'
    )
  end

  def self.for_type(type, token_string)
    token_string ||= '[]'
    klass = {
      types.label => Equations::Label,
      types.sort => Equations::Sort,
      types.nutrition => Equations::Nutrition,
      types.cart => Equations::Cart
    }[type]
    klass.new(token_string)
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
  def initialize(token_string)
    @tokens = JSON.parse(token_string).map(&:with_indifferent_access)
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

  def variable_tokens
    @tokens.map { |token| token[:value] if token[:type] == 'variable' }.compact
  end

  # here we test the equation by evaluating it against fake attributes to check
  # that it returns the right kind of value.
  private def test_value
    @test_value ||= evaluate_with_fake_data
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
