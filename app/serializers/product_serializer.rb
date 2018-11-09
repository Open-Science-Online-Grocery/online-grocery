# frozen_string_literal: true

# responsible for collecting/formatting info about a Product for consumption by
# grocery store react app
class ProductSerializer
  def initialize(product, condition)
    @product = product
    @condition = condition
  end

  def serialize
    return @product.attributes unless gets_label?
    @product.attributes.merge(
      label_image_url: @condition.label_image_url,
      label_position: @condition.label_position,
      label_size: @condition.label_size
    )
  end

  private def gets_label?
    @condition.label_equation.evaluate_with_product(@product)
  end
end
