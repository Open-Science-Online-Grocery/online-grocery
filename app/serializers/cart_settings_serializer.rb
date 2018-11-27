# frozen_string_literal: true

class CartSettingsSerializer
  def initialize(condition, cart_product_data)
    @condition = condition
    @cart_product_data = cart_product_data
  end

  def serialize
    {
      health_label_summary: '8 out of 20 products have a health label',
      label_image_urls: [Label.first.image_url, Label.last.image_url],
      time: Time.zone.now
    }
  end
end
