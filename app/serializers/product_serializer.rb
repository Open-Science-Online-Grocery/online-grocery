# frozen_string_literal: true

# responsible for collecting/formatting info about a Product for consumption by
# grocery store react app
class ProductSerializer
  extend Memoist

  def initialize(product, condition, preloaded_data = {})
    @product = product
    @condition = condition
    @preloaded_data = preloaded_data
  end

  def serialize(include_add_on: true)
    attrs = @product.attributes

    if @preloaded_data[:custom_attribute_amount].present?
      attrs = attrs.merge(custom_attributes_info)
    end
    if @preloaded_data[:custom_price_amount].present?
      attrs = attrs.merge(custom_price_info)
    end

    attrs = attrs.merge(labels: product_labels(attrs))
      .merge(nutrition_information(attrs))
    include_add_on ? attrs.merge(add_on_info) : attrs
  end

  # when sorting by labels, show products the the most labels first
  def label_sort
    product_labels.count * -1
  end

  def custom_attribute_amount
    @preloaded_data[:custom_attribute_amount].to_f
  end

  private def product_labels(attrs = @product.attributes)
    @condition.condition_labels.map do |condition_label|
      label_information(condition_label, attrs)
    end.compact
  end
  memoize :product_labels

  private def label_information(condition_label, attrs)
    return nil unless gets_label?(condition_label, attrs)
    {
      'label_name' => condition_label.name,
      'label_image_url' => condition_label.image_url,
      'label_position' => condition_label.position,
      'label_size' => condition_label.size,
      'label_tooltip' => condition_label.tooltip_text,
      'label_below_button' => condition_label.below_button?
    }
  end

  private def nutrition_information(attrs)
    return {} unless gets_custom_nutrition_styling?(attrs)
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
      'custom_attribute_amount' => @preloaded_data[:custom_attribute_amount]
    }
  end

  private def custom_price_info
    {
      'price' => @preloaded_data[:custom_price_amount] || @product.price,
      'original_price' => @product.price
    }
  end

  private def gets_label?(condition_label, attrs)
    condition_label.equation.evaluate(attrs)
  end

  private def gets_custom_nutrition_styling?(attrs)
    if @condition.style_use_type == @condition.style_use_types.always
      return true
    end
    @condition.nutrition_equation.evaluate(attrs)
  end
end
