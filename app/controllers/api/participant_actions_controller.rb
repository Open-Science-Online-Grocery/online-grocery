# frozen_string_literal: true

module Api
  class ParticipantActionsController < ApplicationController
    include Concerns::GetsCondition

    skip_power_check
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    # rubocop:disable Rails/SaveBang, Metrics/AbcSize
    def create
      condition = condition_from_uuid
      action = ParticipantAction.create(
        session_identifier: params[:session_id],
        condition_id: condition.id,
        action_type: params[:action_type],
        product_id: params[:product_id],
        quantity: params[:quantity],
        serial_position: params[:serial_position]
      )
      json = {
        data: { success: action.valid? },
        errors: action.errors.full_messages.map { |error| { title: error } }
      }
      render json: json
    end
    # rubocop:enable Rails/SaveBang, Metrics/AbcSize
  end
end
