# frozen_string_literal: true

module Api
  class ParticipantActionsController < ApplicationController
    include Support::GetsCondition

    skip_power_check
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    def create
      condition = condition_from_uuid
      creator = ParticipantActionCreator.new(condition, params[:operations])
      success = creator.create_participant_actions
      json = {
        data: { success: success },
        errors: creator.errors.map { |error| { title: error } }
      }
      render(json: json, status: success ? :ok : :unprocessable_entity)
    end
  end
end
