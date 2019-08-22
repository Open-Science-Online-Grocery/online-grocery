# frozen_string_literal: true

require 'csv'

# this script is used to export all products in the database to a CSV in a
# format specified by the client. it is not part of application operations, but
# can be used to allow clients to be able to inspect/edit product data
#
# Use the following in the rails console to run this script:
# load './lib/scripts/product_exporter.rb'
# ProductExporter.new.run
class ProductExporter
  def run(export_filepath = default_export_filepath)
    first_product_row = product_row(products.first)
    CSV.open(export_filepath, 'w') do |csv|
      csv << first_product_row.map(&:first)
      csv << first_product_row.map(&:last)

      products.from(1).each do |product|
        csv << product_row(product).map(&:last)
      end
      nil
    end
  end

  private def products
    @products ||= begin
      Product.includes(:subcategory, :subsubcategory).order(:id).to_a
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  private def product_row(product)
    [
      ['id', product_attribute(product, :id)],
      ['name', product_attribute(product, :name)],
      ['size', product_attribute(product, :size)],
      ['description', product_attribute(product, :description)],
      ['imageSrc', product_attribute(product, :image_src)],
      ['awsImageUrl', product_attribute(product, :aws_image_url)],
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
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private def product_attribute(product, attribute)
    value = product.public_send(attribute)
    return value if value.present?
    # for nutrition fields only, the client uses a convention of indicating
    # null values with "NULL" instead of a blank cell.
    attribute.in?(Product.nutrition_fields) ? 'NULL' : nil
  end

  private def default_export_filepath
    Rails.root.join('lib', 'scripts', 'exported_products.csv')
  end
end
