# frozen_string_literal: true

class AddSerialPositionToParticipantActions < ActiveRecord::Migration[5.2]
  def change
    add_column :participant_actions, :serial_position, :integer
  end
end
