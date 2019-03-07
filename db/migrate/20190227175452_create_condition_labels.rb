# frozen_string_literal: true

class CreateConditionLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :condition_labels do |t|
      t.references :condition, index: true
      t.references :label, index: true
      t.string :position
      t.integer :size
      t.text :equation_tokens
      t.boolean :always_show

      t.timestamps null: false
    end
  end
end
