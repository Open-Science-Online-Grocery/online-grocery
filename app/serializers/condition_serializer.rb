# frozen_string_literal: true

# responsible for collecting/formatting info about a Condition for consumption
# by the grocery store react app
class ConditionSerializer
  extend Memoist

  def initialize(condition)
    @condition = condition
  end

  # rubocop:disable Layout/LineLength, Metrics/AbcSize, Metrics/MethodLength
  def serialize
    {
      sort_fields: @condition.product_sort_fields.map(&:description),
      show_products_by_subcategory: @condition.show_products_by_subcategory,
      categories: categories,
      subcategories: subcategories,
      subsubcategories: subsubcategories,
      tags: @condition.tags.order(:id).uniq,
      subtags: subtags,
      filter_by_tags: @condition.filter_by_custom_categories,
      only_add_to_cart_from_detail_page: @condition.only_add_from_detail_page,
      show_price_total: @condition.show_price_total,
      minimum_spend: @condition.minimum_spend,
      maximum_spend: @condition.maximum_spend,
      may_add_to_cart_by_dollar_amount: @condition.may_add_to_cart_by_dollar_amount,
      show_guiding_stars: @condition.show_guiding_stars,
      qualtrics_code: @condition.qualtrics_code,
      allow_searching: @condition.allow_searching,
      display_old_price: @condition.display_old_price
    }.merge(custom_attributes_info)
  end
  # rubocop:enable Layout/LineLength, Metrics/AbcSize, Metrics/MethodLength

  private def subcategories
    @condition.show_products_by_subcategory ? applicable_subcategories : []
  end

  private def categories
    Category.sorted.where(id: applicable_subcategories.map(&:category_id)).to_a
  end

  private def subsubcategories
    return [] unless @condition.show_products_by_subcategory
    applicable_subcategories.flat_map do |subcategory|
      subcategory.subsubcategories.sorted
    end
  end

  private def subtags
    return [] unless @condition.show_products_by_subcategory
    @condition.subtags.order(:tag_id).uniq
  end

  private def custom_attributes_info
    should_display_custom_attr = @condition.show_custom_attribute_on_product ||
      @condition.show_custom_attribute_on_checkout
    return {} unless should_display_custom_attr
    {
      'display_custom_attr_on_detail' =>
        @condition.show_custom_attribute_on_product,
      'display_custom_attr_on_checkout' =>
        @condition.show_custom_attribute_on_checkout,
      'custom_attr_unit' => @condition.custom_attribute_units,
      'custom_attr_name' => @condition.custom_attribute_name
    }
  end

  private def applicable_subcategories
    @condition.included_subcategories.sorted
  end
  memoize :applicable_subcategories
end
