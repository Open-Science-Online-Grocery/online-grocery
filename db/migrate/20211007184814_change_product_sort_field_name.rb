# frozen_string_literal: true

class ProductSortField < ApplicationRecord
end

class ChangeProductSortFieldName < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.connection.schema_cache.clear!
    ProductSortField.reset_column_information

    ProductSortField.find_by(description: 'Custom label')&.update!(
      name: 'label_sort'
    )
  end

  def down
    ActiveRecord::Base.connection.schema_cache.clear!
    ProductSortField.reset_column_information

    ProductSortField.find_by(description: 'Custom label')&.update!(
      name: 'label_image_url'
    )
  end
end
