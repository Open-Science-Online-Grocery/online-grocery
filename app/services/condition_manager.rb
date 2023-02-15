# frozen_string_literal: true

# responsible for any extra data manipulation needed when setting attributes on
# or saving a condition
class ConditionManager
  extend Memoist

  attr_reader :errors

  def initialize(condition, params)
    @condition = condition
    @params = params
    @active_tag_file = @condition.current_tag_csv_file
    @errors = []
  end

  def assign_params
    @condition.attributes = adjusted_params
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
  def update_condition
    ActiveRecord::Base.transaction do
      assign_params
      validate_cart_summary_label_params
      set_excluded_subcategories
      @errors += @condition.errors.full_messages unless @condition.save
      handle_tag_file_change if @errors.none?
      update_suggestions if @errors.none?
      update_custom_sortings if @errors.none?
      update_custom_product_attribute if @errors.none?
      update_custom_attribute_sort_field if @errors.none?
      update_custom_product_price if @errors.none?
      raise(ActiveRecord::Rollback) if @errors.any?
    end
    @errors.none?
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize

  private def adjusted_params
    adjuster = ConditionParamsAdjuster.new(@params)
    adjuster.adjusted_params
  end
  memoize :adjusted_params

  # This kind of validation could normally be done with
  # `#accepts_nested_attributes_for :reject_if`
  # but in this case, we only want to validate on submit, not
  # on form refresh, which is not supported by reject_if
  private def validate_cart_summary_label_params
    params_to_validate =
      adjusted_params[:condition_cart_summary_labels_attributes]
    return unless params_to_validate
    params_to_validate.each do |_, label_attrs|
      cart_summary_label_missing_error unless cart_image_exists?(label_attrs)
    end
  end

  # this is an unusual implementation: it is more convenient to save only
  # excluded subcategories, but it is more natural for the user to choose
  # *included* subcategories. here we flip 'em.
  private def set_excluded_subcategories
    @condition.excluded_subcategory_ids = Subcategory.where.not(
      id: @condition.included_subcategory_ids
    ).pluck(:id)
  end

  private def handle_tag_file_change
    return if @condition.current_tag_csv_file == @active_tag_file
    importer = TagImporter.new(
      file: adjusted_params[:new_tag_csv_file],
      condition: @condition
    )
    importer.import || @errors += importer.errors
  end

  private def update_custom_attribute_sort_field
    sort_field = ProductSortField.find_by(
      name: 'custom_attribute_amount'
    )
    description = "#{@params['custom_attribute_name']}
      (#{@params['custom_attribute_units']})".capitalize
    if sort_field
      sort_field.update!(
        description: description
      )
    else
      ProductSortField.create!(
        name: 'custom_attribute_amount',
        description: description
      )
    end
  end

  private def update_suggestions
    manager = CsvFileManagers::Suggestion.new(@condition)
    manager.import || @errors += manager.errors
  end

  private def update_custom_sortings
    manager = CsvFileManagers::Sorting.new(@condition)
    manager.import || @errors += manager.errors
  end

  private def update_custom_product_attribute
    manager = CsvFileManagers::ProductAttribute.new(@condition)
    manager.import || @errors += manager.errors
  end

  private def update_custom_product_price
    manager = CsvFileManagers::ProductPrice.new(@condition)
    manager.import || @errors += manager.errors
  end

  private def cart_image_exists?(cart_label_attrs)
    if cart_label_attrs[:label_type] == CartSummaryLabel.types.provided
      return cart_label_attrs[:cart_summary_label_id].present?
    end
    custom_image_cache = cart_label_attrs.dig(
      :cart_summary_label_attributes,
      :image_cache
    )
    custom_image_id = cart_label_attrs.dig(:cart_summary_label_attributes, :id)
    custom_image_cache.present? || custom_image_id.present?
  end

  private def cart_summary_label_missing_error
    @errors << 'A cart summary image must be uploaded or selected ' \
      'for all conditional images'
  end
end
