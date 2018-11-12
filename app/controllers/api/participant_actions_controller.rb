# frozen_string_literal: true

module Api
  class ParticipantActionsController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    # rubocop:disable Metrics/AbcSize, Rails/SaveBang
    def create
      condition = Condition.find_by(uuid: params[:condition_identifier])
      action = ParticipantAction.create(
        session_identifier: params[:session_id],
        condition: condition,
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
