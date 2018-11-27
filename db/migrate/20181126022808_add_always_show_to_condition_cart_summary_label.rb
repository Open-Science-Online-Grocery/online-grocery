# frozen_string_literal: true

class AddAlwaysShowToConditionCartSummaryLabel < ActiveRecord::Migration[5.2]
  def change
    add_column :condition_cart_summary_labels,
               :always_show,
               :boolean,
               required: true,
               default: true
  end
end
