# frozen_string_literal: true

# captures information about attributes relevant to Carts as used in Equations.
#  - `token_name` is a string used for referring to the variable in the
#    calculator react widget and in database columns (like
#    Condition#label_equation_tokens)
#  - `description` is a string that users will see in the UI
#  - `attribute`, if present, indicates an attribute on Product relevant to
#    determining the value of the variable.
class CartVariable < Variable
  # rubocop:disable Metrics/MethodLength
  def self.all
    @all ||= begin
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
      ].map { |attrs| new(attrs) } + total_fields + average_fields
    end
  end
  # rubocop:enable Metrics/MethodLength

  def self.total_fields
    @total_fields ||= begin
      ProductVariable.all.map do |product_variable|
        new(
          token_name: "total_#{product_variable.token_name}",
          description: "Total #{product_variable.description}".capitalize,
          attribute: product_variable.attribute
        )
      end
    end
  end

  def self.average_fields
    @average_fields ||= begin
      ProductVariable.all.map do |product_variable|
        new(
          token_name: "avg_#{product_variable.token_name}",
          description: "Average #{product_variable.description}".capitalize,
          attribute: product_variable.attribute
        )
      end
    end
  end
end
