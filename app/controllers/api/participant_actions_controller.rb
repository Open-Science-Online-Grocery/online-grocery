# frozen_string_literal: true

module Api
  class ParticipantActionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    # TODO: save data
    def create
      render json: {}
    end
  end
end
