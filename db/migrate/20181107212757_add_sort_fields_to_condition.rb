# frozen_string_literal: true

class AddSortFieldsToCondition < ActiveRecord::Migration[5.2]
  def change
    add_reference :conditions, :default_sort_field
    add_column :conditions, :default_sort_order, :string
    add_column :conditions, :sort_equation_tokens, :text
  end
end
