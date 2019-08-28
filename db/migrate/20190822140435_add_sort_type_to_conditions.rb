# frozen_string_literal: true

class AddSortTypeToConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :sort_type, :string
  end
end
