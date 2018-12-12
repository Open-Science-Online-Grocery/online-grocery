# frozen_string_literal: true

class CreateSubsubcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :subsubcategories do |t|
      t.references :subcategory
      t.integer :display_order
      t.string :name

      t.timestamps
    end
  end
end
