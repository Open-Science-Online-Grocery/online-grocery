# frozen_string_literal: true

class CartSummarizer
  delegate :total_products, :number_of_products_with_label,
           :percent_of_products_with_label, to: :@cart

  def initialize(condition, cart)
    @condition = condition
    @cart = cart
  end

  def health_label_summary
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
    "#{percent_of_products_with_label.round}% of products have"
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
