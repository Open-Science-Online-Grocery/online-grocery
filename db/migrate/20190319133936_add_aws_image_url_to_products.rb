# frozen_string_literal: true

class AddAwsImageUrlToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :aws_image_url, :string
  end
end
