# frozen_string_literal: true

# responsible to generating the cart summary text about products with health
# labels for a given cart an condition
class CartSummarizer
  delegate :total_products, :number_of_products_with_each_label,
           :percent_of_products_with_each_label, to: :@cart

  def initialize(condition, cart)
    @condition = condition
    @cart = cart
  end

  def health_label_summaries
    return unless @condition.show_food_count

    @condition.labels.map do |label|
      if @condition.ratio_count?
        prefix = ratio_label_prefix(label)
      else
        prefix = percent_label_prefix(label)
      end
      "#{prefix} #{label_name(label)}"
    end
  end

  private def ratio_label_prefix(label)
    product_count = number_of_products_with_each_label
      .fetch(label.image_url, 0)
    prefix = "#{product_count} out of #{total_products} "

    return prefix + 'products has' if product_count == 1

    prefix + 'products have'
  end

  private def percent_label_prefix(label)
    percentage = percent_of_products_with_each_label
      .fetch(label.image_url, 0).round
    "#{percentage}% of products have"
  end

  private def label_name(label)
    @label_name ||= begin
      return "the #{label.name} label" if label.name.present?
      'a health label'
    end
  end
end
