# frozen_string_literal: true

require 'csv'

# Responsible for importing categories, subcategories, and subsubcategories
# from a CSV file.
class CategoryImporter
  def import
    ActiveRecord::Base.transaction do
      rows = CSV.read(import_filepath, headers: true, encoding: 'ISO-8859-1')
      rows_by_category = rows.group_by { |r| r['Category ID'] }
      rows_by_category.each_value do |category_rows|
        import_category(category_rows)
      end
      Category.where.not(id: rows_by_category.keys).destroy_all
    end
  end

  # @param rows [Enumerable<CSV::Row>] rows pertaining to a single category
  private def import_category(rows)
    category = get_category(rows.first)
    rows_by_subcategory = rows.group_by { |r| r['Subcategory Order'] }
    rows_by_subcategory.each_value do |subcategory_rows|
      import_subcategory(category, subcategory_rows)
    end
    category.subcategories.where.not(
      display_order: rows_by_subcategory.keys
    ).destroy_all
  end

  # @param category [Category]
  # @param rows [Enumerable<CSV::Row>] rows pertaining to a single subcategory
  private def import_subcategory(category, rows)
    subcategory = get_subcategory(category, rows.first)
    rows.each do |row|
      import_subsubcategory(subcategory, row)
    end
    subcategory.subsubcategories.where.not(
      display_order: rows.map { |r| r['Subsubcategory Order'] }
    ).destroy_all
  end

  private def get_category(row)
    category = Category.find_or_initialize_by(id: row['Category ID'])
    category.update!(name: row['Category Name'])
    category
  end

  private def get_subcategory(category, row)
    subcategory = category.subcategories.find_or_initialize_by(
      display_order: row['Subcategory Order']
    )
    subcategory.update!(name: row['Subcategory Name'])
    subcategory
  end

  private def import_subsubcategory(subcategory, row)
    return unless row['Subsubcategory Name'].present?
    subsub = subcategory.subsubcategories.find_or_initialize_by(
      display_order: row['Subsubcategory Order']
    )
    subsub.update!(name: row['Subsubcategory Name'])
  end

  private def import_filepath
    Rails.root.join('db/seeds/base/categories.csv')
  end
end
