# frozen_string_literal: true

class AddCustomAttributeDisplayOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :show_custom_attribute_on_product, :boolean, null: false, default: false
    add_column :conditions, :show_custom_attribute_on_checkout, :boolean, null: false, default: false
  end
end
