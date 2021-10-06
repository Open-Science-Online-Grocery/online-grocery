# frozen_string_literal: true

class CreateCustomSortings < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_sortings do |t|
      t.string :session_identifier
      t.references :condition
      t.references :product
      t.integer :sort_order

      t.timestamps
    end

    add_index :custom_sortings, :session_identifier
  end
end
