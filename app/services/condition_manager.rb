# frozen_string_literal: true

# responsible for any extra data manipulation needed when setting attributes on
# or saving a condition
class ConditionManager
  attr_reader :errors

  def initialize(condition, params)
    @condition = condition
    @params = params
    @errors = []
  end

  def assign_params
    add_uuid_to_new_record
    clear_unselected_label_fields
    show_food_count_fields
    clear_cart_summary_label_fields
    clear_unselected_sort_fields
    @condition.attributes = @params
  end

  def update_condition
    assign_params
    validate_cart_summary_label_params
    @errors += @condition.errors.full_messages unless @condition.save
    @errors.none?
  end

  private def add_uuid_to_new_record
    return unless @condition.new_record?
    @condition.uuid = SecureRandom.uuid
  end

  # rubocop:disable Style/GuardClause
  private def clear_unselected_label_fields
    if @params[:label_type] == Condition.label_types.custom
      @params.delete(:label_id)
    else
      @params.delete(:label_attributes)
    end
    if @params[:label_type] == Condition.label_types.none
      @params[:label_id] = nil
    end
  end

  private def clear_unselected_sort_fields
    if @params[:sort_type] != Condition.sort_types.field
      @params[:default_sort_field_id] = nil
      @params[:default_sort_order] = nil
    end
    if @params[:sort_type] != Condition.sort_types.calculation
      @params[:sort_equation_tokens] = nil
    end
  end

  private def clear_cart_summary_label_fields
    return unless @params[:condition_cart_summary_labels_attributes]
    @params[:condition_cart_summary_labels_attributes].each do |_, val|
      label_type = val[:label_type]
      if label_type == ConditionCartSummaryLabel.label_types.custom
        val.delete(:cart_summary_label_id)
      else
        val.delete(:cart_summary_label_attributes)
      end
    end
  end
  # rubocop:enable Style/GuardClause

  private def show_food_count_fields
    @condition.show_food_count = @params.delete(:show_food_count) == '1'
    @params[:food_count_format] = nil unless @condition.show_food_count
  end

  # This kind of validation could normally be done with
  # `#accepts_nested_attributes_for :reject_if`
  # but in this case, we only want to validate on submit, not
  # on form refresh, which is not supported by reject_if
  private def validate_cart_summary_label_params
    params_to_validate = @params[:condition_cart_summary_labels_attributes]
    return unless params_to_validate
    params_to_validate.each do |_, label_attrs|
      no_provided_image = label_attrs[:cart_summary_label_id].blank?
      no_custom_image = label_attrs.dig(
        :cart_summary_label_attributes,
        :image
      ).blank?
      cart_summary_label_missing_error if no_provided_image && no_custom_image
    end
  end

  private def cart_summary_label_missing_error
    @errors << 'A cart summary image must be uploaded or selected '\
      'for all conditional images'
  end
end
