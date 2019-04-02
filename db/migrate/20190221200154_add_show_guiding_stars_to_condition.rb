# frozen_string_literal: true

class AddShowGuidingStarsToCondition < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :show_guiding_stars, :boolean, default: true
  end
end
