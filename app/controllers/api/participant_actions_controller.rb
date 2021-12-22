# frozen_string_literal: true

module Api
  class ParticipantActionsController < ApplicationController
    include Concerns::GetsCondition

    skip_power_check
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    def create
      condition = condition_from_uuid
      creator = ParticipantActionCreator.new(condition, params[:operations])
      json = {
        data: { success: creator.create_participant_actions },
        errors: creator.errors.map { |error| { title: error } }
      }
      render json: json
    end
  end
end
