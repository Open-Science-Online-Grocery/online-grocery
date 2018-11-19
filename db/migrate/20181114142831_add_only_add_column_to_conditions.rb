# frozen_string_literal: true

class AddOnlyAddColumnToConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :only_add_from_detail_page, :boolean, default: false
  end
end
