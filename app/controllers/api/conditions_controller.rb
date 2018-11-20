# frozen_string_literal: true

module Api
  class ConditionsController < ApplicationController
    skip_power_check
    skip_before_action :authenticate_user!

    def show
      condition = Condition.find_by(uuid: params[:condition_identifier])
      render json: ConditionSerializer.new(condition).serialize.to_json
    end
  end
end
