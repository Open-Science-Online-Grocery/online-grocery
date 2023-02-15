# frozen_string_literal: true

class AddCustomAttributeFieldsToCondition < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :custom_attribute_units, :string
    add_column :conditions, :custom_attribute_name, :string
  end
end
