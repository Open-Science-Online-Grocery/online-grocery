# frozen_string_literal: true

# captures information about attributes relevant to Carts as used in Equations.
#  - `token_name` is a string used for referring to the variable in the
#    calculator react widget and in database columns (like
#    Condition#label_equation_tokens)
#  - `description` is a string that users will see in the UI
#  - `attribute`, if present, indicates an attribute on Product relevant to
#    determining the value of the variable.
class CartVariable
  # rubocop:disable Metrics/MethodLength
  def self.all
    [
      {
        token_name: 'number_of_products_with_label',
        description: 'Number of products with health label',
        attribute: nil
      },
      {
        token_name: 'percent_of_products_with_label',
        description: 'Percent of products with health label',
        attribute: nil
      },
      {
        token_name: 'total_products',
        description: 'Total number of products',
        attribute: nil
      }
    ] + total_fields + average_fields
  end
  # rubocop:enable Metrics/MethodLength

  def self.total_fields
    ProductVariable.all.map do |product_variable|
      {
        token_name: "total_#{product_variable[:token_name]}",
        description: "Total #{product_variable[:description]}".capitalize,
        attribute: product_variable[:attribute]
      }
    end
  end

  def self.average_fields
    ProductVariable.all.map do |product_variable|
      {
        token_name: "avg_#{product_variable[:token_name]}",
        description: "Average #{product_variable[:description]}".capitalize,
        attribute: product_variable[:attribute]
      }
    end
  end

  def self.from_token(token_name)
    all.find { |field| field[:token_name] == token_name }
  end
end
