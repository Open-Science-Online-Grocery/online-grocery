# frozen_string_literal: true

class CreateConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :conditions do |t|
      t.string :name, null: false
      t.references :experiment, index: true, null: false

      t.timestamps
    end
  end
end
