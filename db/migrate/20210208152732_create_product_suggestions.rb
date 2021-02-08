class CreateProductSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :product_suggestions do |t|
      t.references :product
      t.references :add_on_product
      t.references :suggestion_csv_file
      t.references :condition

      t.timestamps
    end
  end
end
