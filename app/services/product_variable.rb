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
  def self.all
    @all ||= nutrition + [
      new(
        token_name: 'price',
        description: 'Price',
        attribute: :price
      )
    ]
  end

  # rubocop:disable Metrics/MethodLength
  def self.nutrition
    @nutrition ||= [
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
    ].map { |attrs| new(attrs) }
  end
  # rubocop:enable Metrics/MethodLength
end
