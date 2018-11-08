# frozen_string_literal: true

module Api
  class ParticipantActionsController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    def create
      action = ParticipantAction.create(
        session_identifier: params[:sessionID],
        condition_identifier: params[:conditionIdentifier],
        action_type: params[:actionType],
        product_name: params[:product],
        quantity: params[:quantity]
      )
      json = {
        data: { success: action.valid? },
        errors: action.errors.full_messages.map { |error| { title: error } }
      }
      render json: json
    end
  end
end
