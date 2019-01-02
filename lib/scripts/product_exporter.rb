# frozen_string_literal: true

require 'csv'

# Use the following in the rails console to run this script:
# load './lib/scripts/product_exporter.rb'
# ProductExporter.new.run
class ProductExporter
  def run
    products = Product.includes(:subcategory, :subsubcategory).order(:id).to_a
    first_product_row = product_row(products.first)

    CSV.open(export_filepath, 'w') do |csv|
      csv << first_product_row.map(&:first)
      csv << first_product_row.map(&:last)

      products.from(1).each_with_index do |product, idx|
        puts "exported product #{idx}" if idx % 1000 == 0
        csv << product_row(product).map(&:last)
      end
      nil
    end
  end

  private def product_row(product)
    [
      ['id', product_attribute(product, :id)],
      ['name', product_attribute(product, :name)],
      ['size', product_attribute(product, :size)],
      ['description', product_attribute(product, :description)],
      ['imageSrc', product_attribute(product, :image_src)],
      ['servingSize', product_attribute(product, :serving_size)],
      ['servings', product_attribute(product, :servings)],
      ['caloriesFromFat', product_attribute(product, :calories_from_fat)],
      ['calories', product_attribute(product, :calories)],
      ['totalFat', product_attribute(product, :total_fat)],
      ['saturatedFat', product_attribute(product, :saturated_fat)],
      ['transFat', product_attribute(product, :trans_fat)],
      ['polyFat', product_attribute(product, :poly_fat)],
      ['monoFat', product_attribute(product, :mono_fat)],
      ['cholesterol', product_attribute(product, :cholesterol)],
      ['sodium', product_attribute(product, :sodium)],
      ['potassium', product_attribute(product, :potassium)],
      ['carbs', product_attribute(product, :carbs)],
      ['fiber', product_attribute(product, :fiber)],
      ['sugar', product_attribute(product, :sugar)],
      ['protein', product_attribute(product, :protein)],
      ['vitamins', product_attribute(product, :vitamins)],
      ['ingredients', product_attribute(product, :ingredients)],
      ['allergens', product_attribute(product, :allergens)],
      ['price', product_attribute(product, :price)],
      ['starpoints', product_attribute(product, :starpoints)],
      ['newcategory', product_attribute(product, :category_id)],
      ['newsubcategory', product.subcategory.display_order],
      ['newsubsubid', product.subsubcategory.try(:display_order) || 'NULL'],
      ['name', product_attribute(product, :name)]
    ]
  end

  private def product_attribute(product, attribute)
    value = product.public_send(attribute)
    return value if value.present?
    attribute.in?(nutrition_fields) ? 'NULL' : nil
  end

  private def nutrition_fields
    %i[
      calories_from_fat
      calories
      total_fat
      saturated_fat
      trans_fat
      poly_fat
      mono_fat
      cholesterol
      sodium
      potassium
      carbs
      fiber
      sugar
      protein
      starpoints
    ]
  end

  private def export_filepath
    Rails.root.join('lib', 'scripts', 'exported_products.csv')
  end
end
