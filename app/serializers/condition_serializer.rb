# frozen_string_literal: true

# responsible for collecting/formatting info about a Condition for consumption
# by the grocery store react app
class ConditionSerializer
  def initialize(condition)
    @condition = condition
  end

  # rubocop:disable Layout/LineLength, Metrics/AbcSize, Metrics/MethodLength
  def serialize
    {
      sort_fields: @condition.product_sort_fields.map(&:description),
      categories: Category.order(:id),
      subcategories: Subcategory.order(:category_id, :display_order),
      subsubcategories: Subsubcategory.order(:subcategory_id, :display_order),
      tags: @condition.tags.order(:id).uniq,
      subtags: @condition.subtags.order(:tag_id).uniq,
      filter_by_tags: @condition.filter_by_custom_categories,
      only_add_to_cart_from_detail_page: @condition.only_add_from_detail_page,
      show_price_total: @condition.show_price_total,
      minimum_spend: @condition.minimum_spend,
      maximum_spend: @condition.maximum_spend,
      may_add_to_cart_by_dollar_amount: @condition.may_add_to_cart_by_dollar_amount,
      show_guiding_stars: @condition.show_guiding_stars,
      qualtrics_code: @condition.qualtrics_code
    }
  end
  # rubocop:enable Layout/LineLength, Metrics/AbcSize, Metrics/MethodLength
end
