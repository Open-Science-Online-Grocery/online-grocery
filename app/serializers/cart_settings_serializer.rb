# frozen_string_literal: true

# responsible for collecting/formatting info about a cart based on a condition,
# for consumption by the grocery store react app
class CartSettingsSerializer
  delegate :total_products, :number_of_products_with_label,
           :percent_of_products_with_label, to: :cart

  def initialize(condition, cart_product_data)
    @condition = condition
    @cart_product_data = cart_product_data
  end

  def serialize
    {
      health_label_summary: health_label_summary,
      show_price_total: @condition.show_price_total,
      show_food_count: @condition.show_food_count,
      label_image_urls: label_image_urls
    }
  end

  private def health_label_summary
    return unless @condition.show_food_count
    if @condition.ratio_count?
      prefix = ratio_label_prefix
    else
      prefix = percent_label_prefix
    end
    "#{prefix} #{label_name}"
  end

  private def ratio_label_prefix
    prefix = "#{number_of_products_with_label} out of #{total_products} "
    return prefix + 'products has' if number_of_products_with_label == 1
    prefix + 'products have'
  end

  private def percent_label_prefix
    "#{percent_of_products_with_label.round}% of products have "
  end

  private def label_name
    @label_name ||= begin
      if @condition.label_name.present?
        return "the #{@condition.label_name} label"
      end
      'a health label'
    end
  end

  private def cart
    @cart ||= Cart.new(@cart_product_data)
  end

  private def label_image_urls
    @condition.condition_cart_summary_labels.select do |condition_cart_label|
      condition_cart_label.applies_to_cart?(cart)
    end.map(&:cart_summary_label_image_url)
  end
end
