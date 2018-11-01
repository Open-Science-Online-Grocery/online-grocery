# frozen_string_literal: true

class AddNutritionStylesToConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :nutrition_styles, :text
  end
end
