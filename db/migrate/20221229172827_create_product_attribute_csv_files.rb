# frozen_string_literal: true

class CreateProductAttributeCsvFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :product_attribute_csv_files do |t|
      t.string :csv_file
      t.references :condition, index: true, null: true
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
