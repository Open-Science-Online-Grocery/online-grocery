# frozen_string_literal: true

class AddLabelIdToConditions < ActiveRecord::Migration[5.2]
  def change
    add_reference :conditions, :label
  end
end
