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
      .merge(product_labels)
      .merge(nutrition_information)
  end

  private def product_labels
    {
      labels: @condition.condition_labels.map do |condition_label|
        label_information(condition_label)
      end.compact
    }
  end

  private def label_information(condition_label)
    return nil unless gets_label?(condition_label)
    {
      'label_name' => condition_label.name,
      'label_image_url' => condition_label.image_url,
      'label_position' => condition_label.position,
      'label_size' => condition_label.size
    }
  end

  private def nutrition_information
    return {} unless gets_custom_nutrition_styling?
    { 'nutrition_style_rules' => @condition.nutrition_styles }
  end

  private def gets_label?(condition_label)
    condition_label.equation.evaluate(@product.attributes)
  end

  private def gets_custom_nutrition_styling?
    if @condition.style_use_type == @condition.style_use_types.always
      return true
    end
    @condition.nutrition_equation.evaluate(@product.attributes)
  end
end
