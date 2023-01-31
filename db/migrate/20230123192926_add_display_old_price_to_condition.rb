# frozen_string_literal: true

class AddDisplayOldPriceToCondition < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :display_old_price, :boolean
  end
end
