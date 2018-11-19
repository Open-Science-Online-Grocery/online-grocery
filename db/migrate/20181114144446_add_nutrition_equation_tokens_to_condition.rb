# frozen_string_literal: true

class AddNutritionEquationTokensToCondition < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :nutrition_equation_tokens, :text
  end
end
