module Concerns
  module GetsCondition
    def condition_from_uuid
      Condition.find_by(uuid: params[:condition_identifier]) ||
        NullCondition.new
    end
  end
end
