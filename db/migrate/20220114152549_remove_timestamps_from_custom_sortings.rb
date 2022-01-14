class RemoveTimestampsFromCustomSortings < ActiveRecord::Migration[5.2]
  def change
    remove_column :custom_sortings, :created_at, :datetime
    remove_column :custom_sortings, :updated_at, :datetime
  end
end
