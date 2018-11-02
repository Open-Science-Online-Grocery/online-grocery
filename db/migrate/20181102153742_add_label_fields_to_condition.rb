# frozen_string_literal: true

class AddLabelFieldsToCondition < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :label_position, :string
    add_column :conditions, :label_size, :integer
  end
end
