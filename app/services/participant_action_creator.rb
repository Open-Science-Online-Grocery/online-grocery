# frozen_string_literal: true

class ParticipantActionCreator
  attr_reader :errors

  def initialize(condition, operations)
    @condition = condition
    @operations = operations
    @errors = []
  end

  def create_participant_actions
    ActiveRecord::Base.transaction do
      @operations.each { |operation_attrs| create_action(operation_attrs) }
      raise ActiveRecord::Rollback if @errors.any?
    end
    @errors.none?
  end

  private def create_action(operation_attrs)
    action = ParticipantAction.new(
      session_identifier: operation_attrs[:session_id],
      condition_id: @condition.id,
      action_type: operation_attrs[:type],
      product_id: operation_attrs[:product_id],
      quantity: operation_attrs[:quantity],
      serial_position: operation_attrs[:serial_position],
      detail: description(operation_attrs),
      frontend_id: operation_attrs[:id],
      performed_at: Time.zone.parse(operation_attrs[:performed_at])
    )
    action.save || @errors += action.errors.full_messages
  end

  private def description(operation_attrs)
    return unless operation_attrs[:type] == 'page view'
    PageDescriber.new(operation_attrs).description
  end
end
