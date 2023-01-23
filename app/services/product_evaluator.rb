# frozen_string_literal: true

# Prepares the data for calculators that use products to be evaluated
class ProductEvaluator
  def initialize(condition, product_attributes)
    @condition = condition
    @product_attributes = product_attributes
  end

  def get_value(variable_token)
    if @product_attributes[variable_token].present?
      return @product_attributes[variable_token]
    end

    variable = ProductVariable.from_token(variable_token.to_s, @condition)
    if variable == ProductVariable.custom_attribute_field(@condition)
      handle_custom_attribute_field
    elsif variable.token_name ==
        ProductVariable.custom_price_field(@condition).token_name
      handle_custom_price_field
    else
      evaluate_product(variable_token)
    end
  end

  private def handle_custom_attribute_field
    if @product_attributes[:custom_attribute_amount].present?
      return @product_attributes[:custom_attribute_amount]
    end
    handle_custom_field(:custom_attribute_amount)
  end

  private def handle_custom_price_field
    if @product_attributes[:original_price].present?
      return @product_attributes[:price]
    end
    handle_custom_field(:custom_price)
  end

  private def handle_custom_field(field)
    product = find_product(@product_attributes['id'])
    return 0 if product.blank?
    product.public_send(field, @condition)
  end

  private def evaluate_product(attribute)
    product = find_product(@product_attributes['id'])
    return 0 if product.blank?
    product.public_send(attribute)
  end

  private def find_product(id)
    return @product if @product&.id == id
    @product = Product.find_by(id: @product_attributes['id'])
  end
end
