# frozen_string_literal: true

class AddDecimalToFatColumns < ActiveRecord::Migration[5.2]
  def up
    change_column :products, :total_fat, :decimal, precision: 10, scale: 1
    change_column :products, :saturated_fat, :decimal, precision: 10, scale: 1
    change_column :products, :trans_fat, :decimal, precision: 10, scale: 1
    change_column :products, :poly_fat, :decimal, precision: 10, scale: 1
    change_column :products, :mono_fat, :decimal, precision: 10, scale: 1
  end

  def down
    change_column :products, :total_fat, :integer
    change_column :products, :saturated_fat, :integer
    change_column :products, :trans_fat, :integer
    change_column :products, :poly_fat, :integer
    change_column :products, :mono_fat, :integer
  end
end
