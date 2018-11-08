# frozen_string_literal: true

# responsible for evaluating equations that users specify using
# the `calculator` React widget
class Calculator
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
end
