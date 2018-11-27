# frozen_string_literal: true

# responsible for collecting/formatting info about a Product for consumption by
# grocery store react app
class ProductSerializer
  def initialize(product, condition)
    @product = product
    @condition = condition
  end

  def serialize
    @product.attributes
      .merge(label_information)
      .merge(nutrition_information)
  end

  private def label_information
    return {} unless gets_label?
    {
      'label_image_url' => @condition.label_image_url,
      'label_position' => @condition.label_position,
      'label_size' => @condition.label_size
    }
  end

  private def nutrition_information
    return {} unless gets_custom_nutrition_styling?
    { 'nutrition_style_rules' => @condition.nutrition_styles }
  end

  private def gets_label?
    @condition.label_equation.evaluate_with_product(@product.attributes)
  end

  private def gets_custom_nutrition_styling?
    if @condition.style_use_type == @condition.style_use_types.always
      return true
    end
    @condition.nutrition_equation.evaluate_with_product(@product.attributes)
  end
end
