# frozen_string_literal: true

class ChangeProductCholesterolToDecimal < ActiveRecord::Migration[5.2]
  def up
    change_column :products, :cholesterol, :decimal, precision: 6, scale: 2
  end

  def down
    change_column :products, :cholesterol, :string
  end
end
