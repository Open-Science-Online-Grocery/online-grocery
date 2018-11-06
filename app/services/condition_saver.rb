# frozen_string_literal: true

# responsible for any extra data manipulation needed when saving a Condition
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

    @condition.attributes = @params
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
end
