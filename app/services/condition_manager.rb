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
    clear_unselected_sort_fields
    clear_unselected_nutrition_fields
    @condition.attributes = @params
  end

  def update_condition
    assign_params
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

  private def clear_unselected_nutrition_fields
    if @params[:style_use_type] == Condition.style_use_types.always
      @params[:nutrition_equation_tokens] = nil
    end
  end
  # rubocop:enable Style/GuardClause
end
