class AddOriginalIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :original_id, :integer
  end
end
