# frozen_string_literal: true

class CreateCustomProductPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_product_prices do |t|
      t.references :condition
      t.references :product_price_csv_file
      t.references :product
      t.decimal :new_price, precision: 64, scale: 12

      t.timestamps
    end
  end
end
