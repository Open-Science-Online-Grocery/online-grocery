# frozen_string_literal: true

class ConditionSaver
  attr_reader :errors

  def initialize(condition, params)
    @condition = condition
    @params = params
    @errors = []
  end

  def save_condition
    add_uuid_to_new_record
    clear_unselected_label_fields
    @errors += @condition.errors.full_messages unless @condition.update(@params)
    @errors.none?
  end

  private def add_uuid_to_new_record
    return unless @condition.new_record?
    @condition.uuid = SecureRandom.uuid
  end

  private def clear_unselected_label_fields
    if @params[:label_type].in?(['none', 'provided'])
      @params.delete(:label_attributes)
    end
    if @params[:label_type] == 'custom'
      @params.delete(:label_id)
    end
    if @params[:label_type] == 'none'
      @params[:label_id] = nil
    end
  end
end
