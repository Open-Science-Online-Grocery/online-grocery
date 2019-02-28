# frozen_string_literal: true

#:nodoc:
class ConditionPresenter < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  alias condition __getobj__

  def current_tag_csv_file_presenter
    ResourcePresenter.new(current_tag_csv_file)
  end

  def historical_tag_csv_files_presenters
    historical_tag_csv_files.map do |tag_csv_file|
      ResourcePresenter.new(tag_csv_file)
    end
  end

  # Returns an array of all the unique Tag/Subtag combinations
  # present on a condition
  def unique_tag_combinations
    tag_combinations = product_tags.map do |product_tag|
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

  def preview_cart_summary_labels
    fake_cart = OpenStruct.new(
      total_products: 3,
      number_of_products_with_label: 2,
      percent_of_products_with_label: 66
    )
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
end
