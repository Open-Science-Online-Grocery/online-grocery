# frozen_string_literal: true

# Prepares the data for calculators that use products to be evaluated
class ProductEvaluator
  def initialize(condition, product_attributes)
    @condition = condition
    @product_attributes = product_attributes
    @product = Product.find_by(id: @product_attributes['id'])
  end

  def get_value(variable_token)
    return 0 if @product.blank?

    variable = ProductVariable.from_token(variable_token.to_s, @condition)
    if variable == ProductVariable.custom_attribute_field(@condition)
      return @product.custom_attribute_amount(@condition)
    end

    evaluate_product(variable_token)
  end

  private def evaluate_product(attribute)
    @product.public_send(attribute)
  end
end
