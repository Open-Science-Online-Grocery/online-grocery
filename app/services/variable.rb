# frozen_string_literal: true

# captures information about attributes relevant to Products and Carts as used
# in Equations.
class Variable
  include ActiveModel::Model

  attr_accessor :token_name, :description, :attribute, :condition

  def self.from_token(token_name, condition = nil)
    all(condition).find do |variable|
      variable.token_name == token_name
    end
  end

  def self.from_attribute(attribute)
    all.find { |variable| variable.attribute == attribute.to_sym }
  end

  def self.format_attr_name(attr)
    attr.underscore.tr(' ', '_')
  end

  def incomplete_data?
    return false unless attribute
    if attribute == :custom_attribute_amount
      Product.where.not(
        id: CustomProductAttribute.where(condition: @condition)
      ).any?
    elsif attribute == :custom_price
      Product.where.not(
        id: CustomProductPrice.where(condition: @condition)
      ).any?
    else
      Product.where(attribute => nil).any?
    end
  end
end
