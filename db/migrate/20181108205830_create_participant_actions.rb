# frozen_string_literal: true

class CreateParticipantActions < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_actions do |t|
      t.string :session_identifier
      t.string :condition_identifier
      t.string :action_type
      t.string :product_name
      t.integer :quantity

      t.timestamps
    end
  end
end
