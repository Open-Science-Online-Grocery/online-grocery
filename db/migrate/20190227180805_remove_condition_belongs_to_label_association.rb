# frozen_string_literal: true

class RemoveConditionBelongsToLabelAssociation < ActiveRecord::Migration[5.2]
  def change
    remove_index :conditions, :label_id

    remove_column :conditions, :label_id, :integer
    remove_column :conditions, :label_position, :string
    remove_column :conditions, :label_size, :integer
    remove_column :conditions, :label_equation_tokens, :text
  end
end
