# frozen_string_literal: true

class ChangeParticipantActionProductNameToId < ActiveRecord::Migration[5.2]
  def change
    remove_column :participant_actions, :product_name, :string
    add_reference :participant_actions, :product
  end
end
