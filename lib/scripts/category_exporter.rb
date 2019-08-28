# frozen_string_literal: true

require 'csv'

# exports the current categories/subcategories/subsubcategories into a CSV
# format that can be consumed by CategoryImporter
#
# Use the following in the rails console to run this script:
# load './lib/scripts/category_exporter.rb'
# CategoryExporter.new.export
class CategoryExporter
  def export
    CSV.open(export_filepath, 'w', encoding: 'ISO-8859-1') do |csv|
      csv << headers
      Subcategory.all.each do |subcategory|
        export_subcategory(csv, subcategory)
      end
    end
  end

  private def export_subcategory(csv, subcategory)
    base_data = subcategory_base_data(subcategory)
    if subcategory.subsubcategories.none?
      csv << base_data + ['', '']
      return
    end
    subcategory.subsubcategories.each do |subsub|
      csv << base_data + [subsub.display_order, subsub.name]
    end
  end

  private def subcategory_base_data(subcategory)
    [
      subcategory.category_id,
      subcategory.category.name,
      subcategory.display_order,
      subcategory.name
    ]
  end

  private def headers
    [
      'Category ID',
      'Category Name',
      'Subcategory Order',
      'Subcategory Name',
      'Subsubcategory Order',
      'Subsubcategory Name'
    ]
  end

  private def export_filepath
    Rails.root.join('lib', 'scripts', 'exported_categories.csv')
  end
end
