# frozen_string_literal: true

# responsible for collecting/formatting info about a Product for consumption by
# grocery store react app
class ProductSerializer
  extend Memoist

  def initialize(product, condition)
    @product = product
    @condition = condition
  end

  def serialize(include_add_on: true)
    attrs = @product.attributes
      .merge(labels: product_labels)
      .merge(nutrition_information)

    should_display_custom_attr = @condition.show_custom_attribute_on_product ||
      @condition.show_custom_attribute_on_checkout

    if should_display_custom_attr && @product.custom_attribute_amount.present?
      attrs = attrs.merge(custom_attribute: custom_attributes_info)
    end
    include_add_on ? attrs.merge(add_on_info) : attrs
  end
  memoize :serialize

  # when sorting by labels, show products the the most labels first
  def label_sort
    product_labels.count * -1
  end

  private def product_labels
    @condition.condition_labels.map do |condition_label|
      label_information(condition_label)
    end.compact
  end
  memoize :product_labels

  private def label_information(condition_label)
    return nil unless gets_label?(condition_label)
    {
      'label_name' => condition_label.name,
      'label_image_url' => condition_label.image_url,
      'label_position' => condition_label.position,
      'label_size' => condition_label.size,
      'label_tooltip' => condition_label.tooltip_text,
      'label_below_button' => condition_label.below_button?
    }
  end

  private def nutrition_information
    return {} unless gets_custom_nutrition_styling?
    { 'nutrition_style_rules' => @condition.nutrition_styles }
  end

  private def add_on_info
    add_on = @product.add_on_product(@condition)
    return {} unless add_on
    add_on_attrs = ProductSerializer.new(add_on, @condition)
      .serialize(include_add_on: false) # avoid recursive add-on suggestions!
    { 'add_on' => add_on_attrs }
  end

  private def custom_attributes_info
    {
      'custom_attribute_unit' => @condition.custom_attribute_units,
      'custom_attribute_name' => @condition.custom_attribute_name,
      'custom_attribute_amount' => @product.custom_attribute_amount,
      'display_on_detail' => @condition.show_custom_attribute_on_product,
      'display_on_checkout' => @condition.show_custom_attribute_on_checkout
    }
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
