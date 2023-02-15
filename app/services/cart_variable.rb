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
    @all = [
      number_of_products_tokens(condition),
      percent_of_products_tokens(condition),
      {
        token_name: 'total_products',
        description: 'Total number of products',
        attribute: nil
      }
    ].flatten.map { |attrs| new(attrs) } +
      total_fields(condition) +
      average_fields(condition) +
      custom_attribute_fields(condition)
  end

  def self.custom_attribute_fields(condition)
    @custom_attribute_fields = product_attribute_fields(condition)
  end

  def self.product_attribute_fields(condition)
    return [] unless condition&.uses_custom_attributes?
    [
      product_attribute_average_field(condition),
      product_attribute_total_field(condition)
    ]
  end

  def self.product_attribute_average_field(condition)
    new(
      token_name: "avg_#{format_attr_name(condition.custom_attribute_name)}",
      description: "Average #{condition.custom_attribute_name}
      (#{condition.custom_attribute_units})".capitalize,
      attribute: :custom_attribute_amount,
      condition: condition
    )
  end

  def self.product_attribute_total_field(condition)
    new(
      token_name: "total_#{format_attr_name(condition.custom_attribute_name)}",
      description: "total #{condition.custom_attribute_name}
      (#{condition.custom_attribute_units})".capitalize,
      attribute: :custom_attribute_amount,
      condition: condition
    )
  end

  def self.total_fields(condition)
    ProductVariable.all(condition).filter_map do |product_variable|
      next if product_variable.attribute == :custom_attribute_amount
      new(
        token_name: "total_#{product_variable.token_name}",
        description: "Total #{product_variable.description}".capitalize,
        attribute: product_variable.attribute,
        condition: condition
      )
    end
  end

  def self.average_fields(condition)
    ProductVariable.all(condition).filter_map do |product_variable|
      next if product_variable.attribute == :custom_attribute_amount
      new(
        token_name: "avg_#{product_variable.token_name}",
        description: "Average #{product_variable.description}".capitalize,
        attribute: product_variable.attribute,
        condition: condition
      )
    end
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
