# frozen_string_literal: true

# responsible for sorting products based on the condition's settings
class ProductSorter
  delegate :default_sort_field_name, :default_sort_order, :sort_equation,
           to: :@condition

  def initialize(product_hashes, condition, sort_field, sort_order)
    @product_hashes = product_hashes
    @condition = condition
  end

  def sorted_products
    case @condition.sort_type
      when Condition.sort_types.none
        @product_hashes
      when Condition.sort_types.field
        field_sorted_products
      when Condition.sort_types.calculation
        calculation_sorted_products
    end
  end

  private def field_sorted_products
    @product_hashes.sort do |a, b|
      comparison = a[sort_field] <=> b[sort_field]
      # comparison will be nil if `a` and `b` are not comparable because one of
      # them (but not both) is nil. we're calling nils "less than" other values
      # and therefore returning -1 if `a` is nil and 1 if `b` is nil.
      comparison ||= a[sort_field].nil? ? -1 : 1
      comparison *= -1 if default_sort_order == 'desc'
      comparison
    end
  end

  private def calculation_sorted_products
    @product_hashes.sort_by do |product_hash|
      sort_equation.evaluate_with_product(product_hash)
    end
  end

  private def sort_field
    default_sort_field_name
  end
end
