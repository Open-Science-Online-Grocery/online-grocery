# frozen_string_literal: true

# responsible for any extra data manipulation needed when setting attributes on
# or saving a condition
class ConditionManager
  attr_reader :errors

  def initialize(condition, params)
    @condition = condition
    @params = params
    @csv_file = nil
    @errors = []
  end

  def assign_params
    add_uuid_to_new_record
    clear_unselected_label_fields
    deactivate_current_csv
    save_csv_file
    show_food_count_fields
    clear_cart_summary_label_fields
    clear_unselected_sort_fields
    clear_unselected_nutrition_fields
    @condition.attributes = @params
  end

  def update_condition
    ActiveRecord::Base.transaction do
      assign_params
      destroy_deactivated_tags
      import_tags
      validate_cart_summary_label_params
      @errors += @condition.errors.full_messages unless @condition.save
      raise ActiveRecord::Rollback if @errors.any?
    end
    @errors.none?
  end

  private def add_uuid_to_new_record
    return unless @condition.new_record?
    @condition.uuid = SecureRandom.uuid
  end

  # rubocop:disable Style/GuardClause
  private def clear_unselected_label_fields
    condition_labels_params = @params[:condition_labels_attributes]
    return unless condition_labels_params.present?

    @params[:condition_labels_attributes] =
      condition_labels_params.transform_values do |condition_label_attrs|
        if condition_label_attrs[:label_type] ==
            ConditionLabel.label_types.custom
          condition_label_attrs.delete(:label_id)
        else
          condition_label_attrs.delete(:label_attributes)
        end

        condition_label_attrs
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

  private def deactivate_current_csv
    active = @params.delete(:active_tag_csv) == '1'
    @condition.active_tag_csv = active
  end

  private def destroy_deactivated_tags
    # coerce to boolean, false is converted to null by ajax form refresh
    active = @condition.active_tag_csv
    current_csv_file = @condition.current_tag_csv_file
    if current_csv_file
      current_csv_file.update!(active: active)
      @condition.product_tags.destroy_all unless active
    end
  end

  private def save_csv_file
    @csv_file = @params[:csv_file]
    return unless @csv_file
    @condition.tag_csv_files.each { |file| file.active = false }
    @condition.tag_csv_files.build(csv_file: @csv_file)
    @params.delete(:csv_file)
  end

  private def import_tags
    # users can only upload one file at a time
    return unless @csv_file.present?

    tag_importer = TagImporter.new(file: @csv_file, condition: @condition)
    @condition.product_tags.destroy_all
    @errors += tag_importer.errors unless tag_importer.import
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

  private def clear_unselected_nutrition_fields
    if @params[:style_use_type] == Condition.style_use_types.always
      @params[:nutrition_equation_tokens] = nil
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
      cart_summary_label_missing_error unless cart_image_exists?(label_attrs)
    end
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
    @errors << 'A cart summary image must be uploaded or selected '\
      'for all conditional images'
  end
end
