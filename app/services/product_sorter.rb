# frozen_string_literal: true

# responsible for sorting products based on the condition's settings and/or the
# sort field/order manually specified by the participant user.
class ProductSorter
  delegate :default_sort_field_name, :default_sort_order, :sort_equation,
           to: :@condition

  def initialize(
    product_hashes, condition, manual_sort_field_description, manual_sort_order
  )
    @product_hashes = product_hashes
    @condition = condition
    @manual_sort_field_description = manual_sort_field_description
    @manual_sort_order = manual_sort_order
  end

  def sorted_products
    return manually_sorted_products if @manual_sort_field_description.present?
    default_sorted_products
  end

  private def manually_sorted_products
    field_sorted_products(manual_sort_field_name, @manual_sort_order)
  end

  private def default_sorted_products
    case @condition.sort_type
      when Condition.sort_types.none
        @product_hashes
      when Condition.sort_types.random
        @product_hashes.shuffle
      when Condition.sort_types.field
        field_sorted_products(default_sort_field_name, default_sort_order)
      when Condition.sort_types.calculation
        calculation_sorted_products
    end
  end

  private def field_sorted_products(sort_field, sort_order)
    @product_hashes.sort do |a, b|
      comparison = a[sort_field] <=> b[sort_field]
      # comparison will be nil if `a` and `b` are not comparable because one of
      # them (but not both) is nil. we're calling nils "less than" other values
      # and therefore returning -1 if `a` is nil and 1 if `b` is nil.
      comparison ||= a[sort_field].nil? ? -1 : 1
      comparison *= -1 if sort_order == 'desc'
      comparison
    end
  end

  private def calculation_sorted_products
    modified_product_hashes.sort_by do |product_hash|
      sort_equation.evaluate(product_hash)
    end
  end

  private def manual_sort_field_name
    ProductSortField.find_by(
      description: @manual_sort_field_description
    ).try(:name)
  end

  # Default any nil values in the products data to 0 for sorting purposes
  private def modified_product_hashes
    @modified_product_hashes ||= @product_hashes.map do |product_hash|
      product_hash.transform_values do |value|
        value.nil? ? 0 : value
      end
    end
  end
end
