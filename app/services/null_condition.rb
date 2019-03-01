# frozen_string_literal: true

# meant to be an inactive stand-in for an actual Condition. its purpose is to
# allow the grocery store react app to function in a default manner when the
# store is visited without specifying a Condition
class NullCondition
  def style_use_types
    Condition.style_use_types
  end

  def id
    nil
  end

  def product_sort_fields
    []
  end

  def tags
    Tag.none
  end

  def subtags
    Subtag.none
  end

  def filter_by_custom_categories
    false
  end

  def only_add_from_detail_page
    false
  end

  def label_equation
    Equation.for_type(Equation.types.label, '[]')
  end

  def style_use_type
    style_use_types.always
  end

  def nutrition_styles
    '{}'
  end

  def sort_type
    Condition.sort_types.none
  end

  def show_price_total
    true
  end

  def condition_cart_summary_labels
    []
  end

  def condition_labels
    []
  end

  def show_food_count
    false
  end

  def minimum_spend
    nil
  end

  def maximum_spend
    nil
  end

  def may_add_to_cart_by_dollar_amount
    false
  end

  def show_guiding_stars
    true
  end
end
