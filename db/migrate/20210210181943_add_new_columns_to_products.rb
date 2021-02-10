# frozen_string_literal: true

class AddNewColumnsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :serving_size_grams, :decimal, precision: 6, scale: 1
    add_column :products, :caloric_density, :decimal, precision: 6, scale: 1
  end
end
