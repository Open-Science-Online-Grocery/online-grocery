# frozen_string_literal: true

class CreateCustomProductAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_product_attributes do |t|
      t.references :condition
      t.references :product_attribute_csv_file
      t.references :product
      t.string :custom_attribute_amount

      t.timestamps
    end
  end
end
