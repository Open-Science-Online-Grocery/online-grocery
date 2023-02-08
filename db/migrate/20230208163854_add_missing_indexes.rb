class AddMissingIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :config_files, [:id, :type]
    add_index :products, :category_id
    add_index :products, :subcategory_id
    add_index :subcategories, :category_id
    add_index :subcategory_exclusions, [:condition_id, :subcategory_id]
  end
end
