# frozen_string_literal: true

class ParticipantAction < ApplicationRecord
end

class BackpopulateParticipantActionsPerformedAt < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.connection.schema_cache.clear!
    ParticipantAction.reset_column_information

    ParticipantAction.where(performed_at: nil).find_each do |participant_action|
      participant_action.update!(performed_at: participant_action.created_at)
    end
  end

  def down
    ActiveRecord::Base.connection.schema_cache.clear!
    ParticipantAction.reset_column_information

    # rubocop:disable Rails/SkipsModelValidations
    ParticipantAction.update_all(performed_at: nil)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
