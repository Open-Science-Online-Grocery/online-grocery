# frozen_string_literal: true

# responsible for collecting/formatting info about a cart based on a condition,
# for consumption by the grocery store react app
class CartSettingsSerializer
  delegate :health_label_summaries, to: :cart_summarizer

  def initialize(condition, cart_product_data)
    @condition = condition
    @cart_product_data = cart_product_data
  end

  def serialize
    {
      health_label_summaries: health_label_summaries,
      label_image_urls: label_image_urls
    }
  end

  private def label_image_urls
    @condition.condition_cart_summary_labels.select do |condition_cart_label|
      condition_cart_label.applies_to_cart?(cart)
    end.map(&:cart_summary_label_image_url)
  end

  private def cart_summarizer
    @cart_summarizer ||= CartSummarizer.new(@condition, cart)
  end

  private def cart
    @cart ||= Cart.new(@cart_product_data)
  end
end
