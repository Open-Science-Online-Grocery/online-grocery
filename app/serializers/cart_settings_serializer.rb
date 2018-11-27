# frozen_string_literal: true

class CartSettingsSerializer
  def initialize(condition, cart_product_data)
    @condition = condition
    @cart_product_data = cart_product_data
  end

  def serialize
    {
      health_label_summary: health_label_summary,
      label_image_urls: [Label.first.image_url, Label.last.image_url],
      show_price_total: @condition.show_price_total,
      show_food_count: @condition.show_food_count
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
    prefix = "#{labeled_product_count} out of #{total_products} "
    return prefix + 'products has' if labeled_product_count == 1
    prefix + 'products have'
  end

  private def percent_label_prefix
    percent = ((labeled_product_count / total_products.to_f) * 100).round
    "#{percent}% of products have "
  end

  private def total_products
    @total_products ||= @cart_product_data.reduce(0) do |total, item|
      total += item['quantity'].to_i
    end
  end

  private def labeled_product_count
    @labeled_product_count ||= @cart_product_data.reduce(0) do |total, item|
      item['has_label'] == 'true' ? total += item['quantity'].to_i : total
    end
  end

  private def label_name
    @label_name ||= begin
      if @condition.label_name.present?
        return "the #{@condition.label_name} label"
      end
      'a health label'
    end
  end
end
