# frozen_string_literal: true

class CreateNutritionStyles < ActiveRecord::Migration[5.2]
  def change
    create_table :nutrition_styles do |t|
      t.references :condition
      t.string :selector
      t.text :rules
      t.boolean :always_apply
      t.text :calculation

      t.timestamps
    end
  end
end
