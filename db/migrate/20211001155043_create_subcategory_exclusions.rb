# frozen_string_literal: true

class CreateSubcategoryExclusions < ActiveRecord::Migration[5.2]
  def change
    create_table :subcategory_exclusions do |t|
      t.references :condition
      t.references :subcategory

      t.timestamps
    end
  end
end
