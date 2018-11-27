# frozen_string_literal: true

class RenameConditionCartSummaryLabelEquationColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :condition_cart_summary_labels, :label_equation_tokens, :equation_tokens
  end
end
