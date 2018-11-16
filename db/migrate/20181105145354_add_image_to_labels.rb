# frozen_string_literal: true

class AddImageToLabels < ActiveRecord::Migration[5.2]
  def change
    add_column :labels, :image, :string
  end
end
