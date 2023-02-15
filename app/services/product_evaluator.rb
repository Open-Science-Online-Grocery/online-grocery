# frozen_string_literal: true

# Prepares the data for calculators that use products to be evaluated
class ProductEvaluator
  def initialize(condition, product_attributes)
    @condition = condition
    @product_attributes = product_attributes
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def get_value(variable_token)
    if @product_attributes.key?(variable_token)
      return @product_attributes[variable_token]
    end

    variable = ProductVariable.from_token(variable_token.to_s, @condition)
    if variable.token_name ==
        ProductVariable.custom_attribute_field(@condition)&.token_name

      handle_custom_attribute_field
    elsif variable.token_name ==
        ProductVariable.custom_price_field(@condition).token_name

      handle_custom_price_field
    else
      evaluate_product(variable_token)
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  private def handle_custom_attribute_field
    unless @product_attributes.symbolize_keys[:custom_attribute_amount].present?
      return
    end
    @product_attributes.symbolize_keys[:custom_attribute_amount]
  end

  private def handle_custom_price_field
    @product_attributes.symbolize_keys[:original_price].present?
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
