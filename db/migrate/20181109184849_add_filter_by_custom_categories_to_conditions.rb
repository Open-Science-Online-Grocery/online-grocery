# frozen_string_literal: true

class AddFilterByCustomCategoriesToConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :filter_by_custom_categories, :boolean, null: false, default: false
  end
end
