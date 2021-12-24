# frozen_string_literal: true

class AddColumnsToParticipantActions < ActiveRecord::Migration[5.2]
  def change
    add_column :participant_actions, :performed_at, :datetime
    add_column :participant_actions, :frontend_id, :string
  end
end
