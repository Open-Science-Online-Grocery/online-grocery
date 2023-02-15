# frozen_string_literal: true

# captures information about attributes relevant to Products as used in
# Equations and ProductSortFields
#  - `token_name` is a string used for referring to the variable in the
#    calculator react widget and in database columns (like
#    Condition#label_equation_tokens)
#  - `description` is a string that users will see in the UI
#  - `attribute` indicates an attribute on Product corresponding to the value of
#    the variable.
class ProductVariable < Variable
  def self.all(condition = nil, include_custom_price: false)
    @all = nutrition(condition) + [
      new(
        token_name: 'price',
        description: 'Price',
        attribute: :price,
        condition: condition
      )
    ] + [custom_attribute_field(condition)]

    @all += [custom_price_field(condition)] if include_custom_price
    @all = @all.compact.flatten
  end

  def self.from_token(token_name, condition = nil)
    all(condition, include_custom_price: true).find do |variable|
      variable.token_name == token_name
    end
  end

  def self.custom_attribute_field(condition)
    @custom_attribute_field = product_attribute_field(condition)
  end

  def self.custom_price_field(condition)
    @custom_price_field = new(
      token_name: 'custom_price',
      description: 'Uses custom price',
      attribute: :custom_price,
      condition: condition
    )
  end

  def self.product_attribute_field(condition)
    return unless condition&.uses_custom_attributes?
    new(
      token_name: format_attr_name(condition.custom_attribute_name),
      description: "#{condition.custom_attribute_name}
        (#{condition.custom_attribute_units})".capitalize,
      attribute: :custom_attribute_amount,
      condition: condition
    )
  end

  # rubocop:disable Metrics/MethodLength
  def self.nutrition(condition = nil)
    @nutrition = [
      {
        token_name: 'serving_size_grams',
        description: 'Serving size (g)',
        attribute: :serving_size_grams
      },
      {
        token_name: 'calories_from_fat',
        description: 'Calories from fat per serving',
        attribute: :calories_from_fat
      },
      {
        token_name: 'calories',
        description: 'Calories per serving',
        attribute: :calories
      },
      {
        token_name: 'caloric_density',
        description: 'Caloric density',
        attribute: :caloric_density
      },
      {
        token_name: 'total_fat',
        description: 'Total fat per serving (g)',
        attribute: :total_fat
      },
      {
        token_name: 'saturated_fat',
        description: 'Saturated fat per serving (g)',
        attribute: :saturated_fat
      },
      {
        token_name: 'trans_fat',
        description: 'Trans fat per serving (g)',
        attribute: :trans_fat
      },
      {
        token_name: 'poly_fat',
        description: 'Polyunsaturated fat per serving (g)',
        attribute: :poly_fat
      },
      {
        token_name: 'mono_fat',
        description: 'Monounsaturated fat per serving (g)',
        attribute: :mono_fat
      },
      {
        token_name: 'cholesterol',
        description: 'Cholesterol per serving (mg)',
        attribute: :cholesterol
      },
      {
        token_name: 'sodium',
        description: 'Sodium per serving (mg)',
        attribute: :sodium
      },
      {
        token_name: 'potassium',
        description: 'Potassium per serving (mg)',
        attribute: :potassium
      },
      {
        token_name: 'carbs',
        description: 'Total carbohydrates per serving (g)',
        attribute: :carbs
      },
      {
        token_name: 'fiber',
        description: 'Dietary fiber per serving (g)',
        attribute: :fiber
      },
      {
        token_name: 'sugar',
        description: 'Sugars per serving (g)',
        attribute: :sugar
      },
      {
        token_name: 'protein',
        description: 'Protein per serving (g)',
        attribute: :protein
      },
      {
        token_name: 'starpoints',
        description: 'Star points',
        attribute: :starpoints
      }
    ].map { |attrs| new(attrs.merge(condition: condition)) }
  end
  # rubocop:enable Metrics/MethodLength
end
