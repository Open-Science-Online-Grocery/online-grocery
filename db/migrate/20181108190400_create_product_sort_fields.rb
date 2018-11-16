# frozen_string_literal: true

class CreateProductSortFields < ActiveRecord::Migration[5.2]
  def change
    create_table :product_sort_fields do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
