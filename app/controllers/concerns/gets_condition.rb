# frozen_string_literal: true

module Concerns
  # identifies a Condition based on its uuid; returns a NullCondition otherwise
  module GetsCondition
    def condition_from_uuid
      Condition.find_by(uuid: params[:condition_identifier]) ||
        NullCondition.new
    end
  end
end
