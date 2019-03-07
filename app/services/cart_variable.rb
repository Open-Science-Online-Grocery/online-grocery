# frozen_string_literal: true

# captures information about attributes relevant to Carts as used in Equations.
#  - `token_name` is a string used for referring to the variable in the
#    calculator react widget and in database columns (like
#    Condition#label_equation_tokens)
#  - `description` is a string that users will see in the UI
#  - `attribute`, if present, indicates an attribute on Product relevant to
#    determining the value of the variable.
class CartVariable < Variable
  def self.all(condition = nil)
    @all ||= begin
      [
        number_of_products_tokens(condition),
        percent_of_products_tokens(condition),
        {
          token_name: 'total_products',
          description: 'Total number of products',
          attribute: nil
        }
      ].flatten.map { |attrs| new(attrs) } + total_fields + average_fields
    end
  end

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

  def self.from_token(token_name, condition = nil)
    all(condition).find { |variable| variable.token_name == token_name }
  end

  def self.from_attribute(attribute, condition = nil)
    all(condition).find { |variable| variable.attribute == attribute.to_sym }
  end

  private_class_method def self.number_of_products_tokens(condition)
    return unless condition.present?

    condition.labels.map do |label|
      {
        token_name: "number_of_products_with_#{label.name}_label",
        description: "Number of products with #{label.name} label",
        attribute: nil
      }
    end
  end

  private_class_method def self.percent_of_products_tokens(condition)
    return unless condition.present?

    condition.labels.map do |label|
      {
        token_name: "percent_of_products_with_#{label.name}_label",
        description: "Percent of products with #{label.name} label",
        attribute: nil
      }
    end
  end
end
