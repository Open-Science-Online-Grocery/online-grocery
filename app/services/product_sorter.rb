# frozen_string_literal: true

# responsible for sorting products based on the condition's settings and/or the
# sort field/order manually specified by the participant user.
class ProductSorter
  extend Memoist

  delegate :default_sort_field_name, :default_sort_order, :sort_equation,
           to: :@condition

  def initialize(
    product_hashes,
    condition,
    session_identifier:,
    manual_sort_field_description:,
    manual_sort_order:
  )
    @product_hashes = product_hashes
    @condition = condition
    @session_identifier = session_identifier
    @manual_sort_field_description = manual_sort_field_description
    @manual_sort_order = manual_sort_order
  end

  def sorted_products
    if @manual_sort_field_description.present?
      result = manually_sorted_products
    else
      result = default_sorted_products
    end
    add_serial_position(result)
  end

  private def manually_sorted_products
    field_sorted_products(manual_sort_field_name, @manual_sort_order)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
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
      when Condition.sort_types.file
        custom_sorted_products
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

  private def add_serial_position(sorted_product_hashes)
    sorted_product_hashes.map.with_index(1) do |product_hash, idx|
      product_hash[:serial_position] = idx
      product_hash
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

  private def custom_sorted_products
    return @product_hashes if participant_sort_data.none?
    @product_hashes.sort_by do |product_hash|
      sort_data = participant_sort_data[product_hash['id']]
      # for products where a sort order was not specified, show them at the
      # end of the list.
      sort_data&.sort_order || Float::INFINITY
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

  private def participant_sort_data
    @condition.custom_sortings
      .for_session_identifier(@session_identifier)
      .index_by(&:product_id)
  end
  memoize :participant_sort_data
end
