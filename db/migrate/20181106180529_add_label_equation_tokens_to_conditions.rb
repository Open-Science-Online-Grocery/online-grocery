# frozen_string_literal: true

class AddLabelEquationTokensToConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :label_equation_tokens, :text
  end
end
