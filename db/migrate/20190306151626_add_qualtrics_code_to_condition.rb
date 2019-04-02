# frozen_string_literal: true

class AddQualtricsCodeToCondition < ActiveRecord::Migration[5.2]
  def change
    add_column :conditions, :qualtrics_code, :string
  end
end
