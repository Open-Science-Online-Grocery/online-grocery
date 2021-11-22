# frozen_string_literal: true

class AddDetailToParticipantActions < ActiveRecord::Migration[5.2]
  def change
    add_column :participant_actions, :detail, :string
  end
end
