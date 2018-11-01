# frozen_string_literal: true

class CreateSubcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :subcategories do |t|
      t.integer :category_id
      t.integer :display_order
      t.string :name

      t.timestamps
    end
  end
end
