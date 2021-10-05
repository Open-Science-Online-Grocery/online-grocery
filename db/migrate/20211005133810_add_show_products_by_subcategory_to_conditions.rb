# frozen_string_literal: true

class AddShowProductsBySubcategoryToConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :show_products_by_subcategory, :boolean, default: true
  end
end
