# frozen_string_literal: true

class AddBudgetingColumnsToConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :minimum_spend, :decimal, precision: 10, scale: 2
    add_column :conditions, :maximum_spend, :decimal, precision: 10, scale: 2
    add_column :conditions, :may_add_to_cart_by_dollar_amount, :boolean, default: false
  end
end
