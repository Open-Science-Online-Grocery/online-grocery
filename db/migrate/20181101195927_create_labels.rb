# frozen_string_literal: true

class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.string :name
      t.boolean :built_in, default: false

      t.timestamps
    end
  end
end
