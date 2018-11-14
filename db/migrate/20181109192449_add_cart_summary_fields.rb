# frozen_string_literal: true

class AddCartSummaryFields < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :show_price_total, :boolean, null: false, default: false
    add_column :conditions, :food_count_format, :string
  end
end
