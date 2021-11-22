# frozen_string_literal: true

# responsible for sorting products based on the condition's settings and/or the
# sort field/order manually specified by the participant user.
class ProductSorter
  extend Memoist

  delegate :default_sort_field_name, :default_sort_order, :sort_equation,
           to: :@condition

  def initialize(
    condition:,
    product_relation:,
    session_identifier:,
    manual_sort_field_description:,
    manual_sort_order:
  )
    @condition = condition
    @product_relation = product_relation
    @session_identifier = session_identifier
    @manual_sort_field_description = manual_sort_field_description
    @manual_sort_order = manual_sort_order
  end

  def sorted_products
    product_list.map.with_index(1) do |product_serializer, idx|
      product_serializer.serialize.merge(serial_position: idx)
    end
  end

  private def product_list
    if @manual_sort_field_description.present?
      manually_sorted_products
    else
      condition_sorted_products
    end
  end

  private def manually_sorted_products
    field_sorted_products(manual_sort_field_name, @manual_sort_order)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  private def condition_sorted_products
    case @condition.sort_type
      when Condition.sort_types.none
        default_sorted_products
      when Condition.sort_types.random
        as_serializers(@product_relation.order(Arel.sql('rand()')))
      when Condition.sort_types.field
        field_sorted_products(default_sort_field_name, default_sort_order)
      when Condition.sort_types.calculation
        calculation_sorted_products
      when Condition.sort_types.file
        custom_sorted_products
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

  private def default_sorted_products
    as_serializers(@product_relation)
  end

  # some sort fields map onto db columns, in which case we can let the db handle
  # the sorting. unfortunately, some sort fields are dependent on calculations
  # that the database can't do, in which case we have to sort the serializers
  # in ruby.
  # rubocop:disable Metrics/PerceivedComplexity
  private def field_sorted_products(sort_field, sort_direction = nil)
    sort_direction ||= :asc
    if sort_field.in?(@product_relation.column_names)
      as_serializers(@product_relation.order(sort_field => sort_direction))
    else
      result = as_serializers(@product_relation).sort_by(&sort_field.to_sym)
      sort_direction.to_sym == :asc ? result : result.reverse
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  private def calculation_sorted_products
    as_serializers(@product_relation).sort_by do |serializer|
      modified_hash = serializer.serialize.transform_values do |value|
        value.nil? ? 0 : value
      end
      sort_equation.evaluate(modified_hash)
    end
  end

  # NOTE: if no custom sorting at all was specified for the current participant
  # (session_identifier), we just return the default-sorted products. if some,
  # but not all products have custom sortings for this participant, only
  # products with a custom sorting specified will be returned.
  #
  # the `select` calls are needed for some database settings that require a
  # column used for sorting to be present in the list of selected columns.
  private def custom_sorted_products
    sorted_relation = @product_relation.joins(:custom_sortings)
      .select(Product.arel_table[Arel.star])
      .select(CustomSorting.arel_table[:sort_order])
      .where(
        custom_sortings: {
          condition_id: @condition.id,
          session_identifier: @session_identifier
        }
      ).order(CustomSorting.arel_table[:sort_order])
    return default_sorted_products unless sorted_relation.exists?
    as_serializers(sorted_relation)
  end

  private def as_serializers(products)
    products.map { |product| ProductSerializer.new(product, @condition) }
  end

  private def manual_sort_field_name
    ProductSortField.find_by(
      description: @manual_sort_field_description
    ).try(:name)
  end
end
