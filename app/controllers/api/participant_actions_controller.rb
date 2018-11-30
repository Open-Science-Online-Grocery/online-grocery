# frozen_string_literal: true

module Api
  class ParticipantActionsController < ApplicationController
    include Concerns::GetsCondition

    skip_power_check
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    # rubocop:disable Metrics/AbcSize, Rails/SaveBang
    def create
      condition = condition_from_uuid
      action = ParticipantAction.create(
        session_identifier: params[:session_id],
        condition_id: condition.id,
        action_type: params[:action_type],
        product_name: params[:product],
        quantity: params[:quantity]
      )
      json = {
        data: { success: action.valid? },
        errors: action.errors.full_messages.map { |error| { title: error } }
      }
      render json: json
    end
    # rubocop:enable Metrics/AbcSize, Rails/SaveBang
  end
end
