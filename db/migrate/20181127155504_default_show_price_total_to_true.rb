# frozen_string_literal: true

class DefaultShowPriceTotalToTrue < ActiveRecord::Migration[5.2]
  def change
    change_column_default :conditions, :show_price_total, from: false, to: true
  end
end
