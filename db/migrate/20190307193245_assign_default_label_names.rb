# frozen_string_literal: true

class Label < ApplicationRecord
  self.table_name = 'labels'
end

class AssignDefaultLabelNames < ActiveRecord::Migration[5.2]
  def up
    Label.connection.schema_cache.clear!
    Label.reset_column_information

    Label.where(name: nil).find_each do |label|
      label.update(name: "Label #{label.id}")
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
