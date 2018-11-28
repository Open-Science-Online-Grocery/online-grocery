class NullCondition
  def style_use_types
    Condition.style_use_types
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
    Equation.for_type('[]', Equation.types.label)
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
end
