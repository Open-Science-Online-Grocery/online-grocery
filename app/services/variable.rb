# frozen_string_literal: true

# captures information about attributes relevant to Products and Carts as used
# in Equations.
class Variable
  include ActiveModel::Model

  attr_accessor :token_name, :description, :attribute

  def self.from_token(token_name)
    all.find { |variable| variable.token_name == token_name }
  end

  def self.from_attribute(attribute)
    all.find { |variable| variable.attribute == attribute.to_sym }
  end

  def self.product_attribute_fields(condition)
    if condition.blank? ||
        condition.custom_product_attributes.empty?
      return []
    end
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
      attribute: :custom_attribute
    )
  end

  def self.product_attribute_total_field(condition)
    new(
      token_name: "total_#{format_attr_name(condition.custom_attribute_name)}",
      description: "total #{condition.custom_attribute_name}
      (#{condition.custom_attribute_units})".capitalize,
      attribute: :custom_attribute
    )
  end

  def self.format_attr_name(attr)
    attr.underscore.tr(' ', '_')
  end

  def incomplete_data?
    return false unless attribute
    return true if attribute == :custom_attribute
    Product.where(attribute => nil).any?
  end
end
