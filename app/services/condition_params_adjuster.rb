# frozen_string_literal: true

# responsible for any adjustments needed on submitted Condition form params
# before assigning them to the record
class ConditionParamsAdjuster
  def initialize(params)
    @params = params.dup
  end

  def adjusted_params
    handle_new_config_files
    clear_unselected_label_fields
    clear_food_count_format
    clear_cart_summary_label_fields
    clear_unselected_sort_fields
    clear_unselected_nutrition_fields
    adjust_selected_subcategories
    @params
  end

  # don't let the current file mark itself `active` if the user is
  # submitting a new file.
  private def handle_new_config_files
    if @params[:new_suggestion_csv_file]
      @params.delete(:suggestion_csv_files_attributes)
    end
    @params.delete(:tag_csv_files_attributes) if @params[:new_tag_csv_file]
  end

  private def clear_unselected_label_fields
    condition_labels_params = @params[:condition_labels_attributes]
    return unless condition_labels_params.present?

    @params[:condition_labels_attributes] =
      condition_labels_params.transform_values do |condition_label_attrs|
        transform_label_attrs(condition_label_attrs)
      end
  end

  private def clear_food_count_format
    @params[:food_count_format] = nil unless @params[:show_food_count] == '1'
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

  # rubocop:disable Style/GuardClause
  private def clear_unselected_sort_fields
    if @params[:sort_type] != Condition.sort_types.field
      @params[:default_sort_field_id] = nil
      @params[:default_sort_order] = nil
    end
    if @params[:sort_type] != Condition.sort_types.calculation
      @params[:sort_equation_tokens] = nil
    end
  end

  private def clear_unselected_nutrition_fields
    if @params[:style_use_type] != Condition.style_use_types.calculation
      @params[:nutrition_equation_tokens] = nil
    end
  end
  # rubocop:enable Style/GuardClause

  private def adjust_selected_subcategories
    ids = @params.fetch(:included_subcategory_ids, []).map(&:to_i)
    @params[:included_subcategory_ids] = ids - Subcategory.where.not(
      category_id: @params.fetch(:included_category_ids, []).select(&:present?)
    ).pluck(:id)
  end

  private def transform_label_attrs(condition_label_attrs)
    if condition_label_attrs[:label_type] == ConditionLabel.label_types.custom
      condition_label_attrs.delete(:label_id)
    else
      condition_label_attrs.delete(:label_attributes)
    end
    condition_label_attrs
  end
end
