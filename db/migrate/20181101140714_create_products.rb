# frozen_string_literal: true

# note: this migration is meant to create tables locally that already exist in
# the client's database - we have no control over the column names or types.
class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :size
      t.text :description
      t.string :imageSrc
      t.string :servingSize
      t.string :servings
      t.integer :caloriesFromFat
      t.integer :calories
      t.integer :totalFat
      t.integer :saturatedFat
      t.integer :transFat
      t.integer :polyFat
      t.integer :monoFat
      t.string  :cholesterol
      t.integer :sodium
      t.integer :potassium
      t.integer :carbs
      t.integer :fiber
      t.integer :sugar
      t.integer :protein
      t.text :vitamins
      t.text :ingredients
      t.text :allergens
      t.decimal :price, precision: 64, scale: 12
      t.integer :category
      t.integer :subcategory
      t.integer :starpoints

      t.timestamps
    end
  end
end
