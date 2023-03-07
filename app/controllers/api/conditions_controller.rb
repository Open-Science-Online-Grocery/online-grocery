# frozen_string_literal: true

module Api
  class ConditionsController < ApplicationController
    include Support::GetsCondition

    skip_power_check
    skip_before_action :authenticate_user!

    def show
      condition = condition_from_uuid
      render json: ConditionSerializer.new(condition).serialize.to_json
    end
  end
end
