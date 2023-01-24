# frozen_string_literal: true

# Prepares the data for calculators that use products to be evaluated
class ProductEvaluator
  def initialize(condition, product_attributes)
    @condition = condition
    @product_attributes = product_attributes
  end

  def get_value(variable_token)
    if @product_attributes.key?(variable_token)
      return @product_attributes[variable_token]
    end

    variable = ProductVariable.from_token(variable_token.to_s, @condition)
    if variable == ProductVariable.custom_attribute_field(@condition)
      if @product_attributes.key?(:custom_attribute_amount)
        return @product_attributes[:custom_attribute_amount]
      end

      product = Product.find_by(id: @product_attributes['id'])
      return 0 if product.blank?
      return product.custom_attribute_amount(@condition)
    end

    evaluate_product(variable_token)
  end

  private def evaluate_product(attribute)
    product = Product.find_by(id: @product_attributes['id'])
    return 0 if product.blank?
    product.public_send(attribute)
  end
end
