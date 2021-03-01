class ChangeProductsImgSrcToText < ActiveRecord::Migration[5.2]
  def up
    change_column :products, :image_src, :text
  end

  def down
    change_column :products, :image_src, :string
  end
end
