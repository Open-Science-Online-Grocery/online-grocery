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

  def self.product_variables
    {
      calories_from_fat: 'Calories from fat per serving',
      calories: 'Calories per serving',
      total_fat: 'Total fat per serving (g)',
      saturated_fat: 'Saturated fat per serving (g)',
      trans_fat: 'Trans fat per serving (g)',
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

  def self.cart_variables
    {
      number_of_products_with_label: 'Number of products with health label',
      percent_of_products_with_label: 'Percent of products with health label',
      avg_calories_from_fat: 'Average calories from fat per serving',
      avg_calories: 'Average calories per serving',
      avg_total_fat: 'Average total fat per serving (g)',
      avg_saturated_fat: 'Average saturated fat per serving (g)',
      avg_trans_fat: 'Average trans fat per serving (g)',
      avg_cholesterol: 'Average cholesterol per serving (mg)',
      avg_sodium: 'Average sodium per serving (mg)',
      avg_carbs: 'Average total carbohydrates per serving (g)',
      avg_fiber: 'Average dietary fiber per serving (g)',
      avg_sugar: 'Average sugars per serving (g)',
      avg_protein: 'Average protein per serving (g)',
      avg_price: 'Average price',
      avg_starpoints: 'Average star points'
    }
    # TODO: add "total" version of most facts as well
  end

  def self.for_type(token_string, type)
    klass = {
      types.label => Equations::Label,
      types.sort => Equations::Sort,
      types.nutrition => Equations::Nutrition,
      types.cart => Equations::Cart
    }[type]
    klass.new(token_string, type)
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

  def variables
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
