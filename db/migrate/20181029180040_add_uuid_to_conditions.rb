# frozen_string_literal: true

class AddUuidToConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :uuid, :string, null: false
  end
end
