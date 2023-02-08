# frozen_string_literal: true

class AddMissingIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :config_files, %i[id type], if_not_exists: true
    add_index :products, :category_id, if_not_exists: true
    add_index :products, :subcategory_id, if_not_exists: true
    add_index :subcategories, :category_id, if_not_exists: true
    add_index :subcategory_exclusions, %i[condition_id subcategory_id], if_not_exists: true
  end
end
