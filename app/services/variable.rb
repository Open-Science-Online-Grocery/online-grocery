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

  def incomplete_data?
    return false unless attribute
    Product.where(attribute => nil).any?
  end
end
