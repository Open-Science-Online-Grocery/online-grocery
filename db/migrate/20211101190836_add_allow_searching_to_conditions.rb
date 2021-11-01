# frozen_string_literal: true

class AddAllowSearchingToConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :allow_searching, :boolean, default: true
  end
end
