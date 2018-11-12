class ChangeProductColumnNamesToSnakeCase < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :imageSrc, :image_src
    rename_column :products, :servingSize, :serving_size
    rename_column :products, :caloriesFromFat, :calories_from_fat
    rename_column :products, :saturatedFat, :saturated_fat
    rename_column :products, :transFat, :trans_fat
    rename_column :products, :polyFat, :poly_fat
    rename_column :products, :monoFat, :mono_fat
    rename_column :products, :totalFat, :total_fat
    rename_column :products, :category, :category_id
    rename_column :products, :subcategory, :subcategory_id
  end
end
