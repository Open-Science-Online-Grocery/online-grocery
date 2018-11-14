# frozen_string_literal: true

class CreateConditionProductSortFields < ActiveRecord::Migration[5.2]
  def change
    create_table :condition_product_sort_fields do |t|
      t.references :condition
      t.references :product_sort_field

      t.timestamps
    end
  end
end
