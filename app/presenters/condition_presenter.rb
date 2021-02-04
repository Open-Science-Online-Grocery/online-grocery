# frozen_string_literal: true

#:nodoc:
class ConditionPresenter < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  alias condition __getobj__

  # Returns an array of all the unique Tag/Subtag combinations
  # present on a condition
  def unique_tag_combinations
    tag_combinations = product_tags.includes(:tag, :subtag).map do |product_tag|
      [product_tag.tag, product_tag.subtag]
    end
    tag_combinations.uniq
  end

  def formatted_minimum_spend
    format_spend(minimum_spend)
  end

  def formatted_maximum_spend
    format_spend(maximum_spend)
  end

  # Due to the random nature of the label selection, the data will be random
  # each time the page is reloaded, meaning the preview will not be consistent
  # switching between ratio and percent view
  def preview_cart_summary_labels
    summarizer = CartSummarizer.new(condition, fake_cart)
    summarizer.health_label_summaries
  end

  def preview_cart_image_urls
    condition_cart_summary_labels.reject(&:marked_for_destruction?)
      .map(&:cart_summary_label_image_url)
  end

  def incomplete_sort_fields
    product_sort_fields.select(&:incomplete_data?)
  end

  private def format_spend(amount)
    number_with_precision(amount, precision: 2)
  end

  private def fake_cart
    fake_cart_data = Product.first(4).pluck(:id).map do |id|
      OpenStruct.new(
        id: id.to_s,
        quantity: '1',
        has_labels: random_labels
      )
    end

    Cart.new(fake_cart_data, condition)
  end

  private def random_labels
    return [] unless condition.labels.present?
    condition.labels.map do |label|
      label.name if rand(0..100) % 4 == 0
    end.compact || []
  end
end
