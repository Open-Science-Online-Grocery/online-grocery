# frozen_string_literal: true

class AddUniqueConstraintToLabelName < ActiveRecord::Migration[5.2]
  def change
    add_index :labels, :name, unique: true
  end
end
