# frozen_string_literal: true

class Condition < ApplicationRecord
  def self.sort_types
    OpenStruct.new(
      none: 'none',
      field: 'field',
      calculation: 'calculation',
      random: 'random'
    )
  end
end

class BackpopulateSortTypes < ActiveRecord::Migration[5.2]
  def up
    Condition.where(sort_type: nil).find_each do |condition|
      if condition.default_sort_field_id
        sort_type = Condition.sort_types.field
      elsif condition.sort_equation_tokens
        sort_type = Condition.sort_types.calculation
      else
        sort_type = Condition.sort_types.none
      end

      condition.update!(sort_type: sort_type)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
