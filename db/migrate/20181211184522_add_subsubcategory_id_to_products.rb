# frozen_string_literal: true

class AddSubsubcategoryIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :subsubcategory
  end
end
