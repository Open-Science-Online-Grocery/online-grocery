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
      tags: @condition.tags.order(:id),
      subtags: @condition.subtags.order(:tag_id),
      filter_by_tags: @condition.filter_by_custom_categories
    }
  end
end
