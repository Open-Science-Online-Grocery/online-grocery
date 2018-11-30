# frozen_string_literal: true

# responsible for collecting/formatting info about a Condition for consumption
# by the grocery store react app
class ConditionSerializer
  def initialize(condition)
    @condition = condition
  end

  def serialize
    {
      sort_fields: @condition.product_sort_fields.map(&:description),
      categories: Category.order(:id),
      subcategories: Subcategory.order(:category_id, :display_order),
      tags: @condition.tags.order(:id).uniq,
      subtags: @condition.subtags.order(:tag_id).uniq,
      filter_by_tags: @condition.filter_by_custom_categories,
      only_add_to_cart_from_detail_page: @condition.only_add_from_detail_page
    }
  end
end
