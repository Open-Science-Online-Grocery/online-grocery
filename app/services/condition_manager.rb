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

  private def clear_unselected_label_fields
    if @params[:label_type].in?(%w[none provided])
      @params.delete(:label_attributes)
    end
    @params.delete(:label_id) if @params[:label_type] == 'custom'
    @params[:label_id] = nil if @params[:label_type] == 'none'
  end

  private def clear_cart_summary_label_fields
    @params[:condition_cart_summary_labels_attributes].each do |_, val|
      label_type = val[:label_type]
      if label_type == 'custom'
        val.delete(:cart_summary_label_id)
      else
        val.delete(:cart_summary_label_attributes)
      end
    end
  end

  private def show_food_count_fields
    @condition.show_food_count = @params.delete(:show_food_count) == '1'
    unless @condition.show_food_count
      @condition.food_count_format = nil
      @params[:food_count_format] = nil
    end
  end
end
