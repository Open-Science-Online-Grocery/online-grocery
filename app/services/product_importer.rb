# frozen_string_literal: true

require 'csv'

# responsible for importing product data from a spreadsheet. change the value
# returned by #total_count if the number of products in the spreadsheet changes.
class ProductImporter
  def initialize(only_random_subset: false)
    @only_random_subset = only_random_subset
    @sampled_rows = (1..total_count).to_a.sample(1000)
    @imported_ids = []
  end

  # rubocop:disable Rails/Output
  def import
    ActiveRecord::Base.transaction do
      i = 0
      CSV.foreach(import_filepath, headers: true) do |row|
        i += 1
        import_row(row) if sampled_row?(i)
        puts("imported product #{i}") if i % 1000 == 0
      end
      Product.where.not(id: @imported_ids).destroy_all
    end
  end
  # rubocop:enable Rails/Output

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  private def import_row(row)
    return unless row['id']
    cleaned_row = clean_row(row)
    product_attrs = cleaned_row.except(
      'category_id', # the ID of the product's Category
      'subcategory_order', # the display order of the product's Subcategory
      'subsubcategory_order' # the display order of the product's Subsubcategory
    )
    category = Category.find_by(id: cleaned_row['category_id'])
    subcategory = category.subcategories.find_by(
      display_order: cleaned_row['subcategory_order']
    )
    subsubcategory = subcategory.subsubcategories.find_by(
      display_order: cleaned_row['subsubcategory_order']
    )
    product_attrs.merge!(
      category_id: category.id,
      subcategory_id: subcategory.id,
      subsubcategory_id: subsubcategory.try(:id)
    )
    product = Product.find_or_initialize_by(id: row['id'])
    product.update!(product_attrs)
    @imported_ids << row['id']
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private def clean_row(row)
    cleaned_row = row.to_h.reduce({}) do |new_row, (key, value)|
      # 'NULL' will be inappropriately cast to `0` for integer columns, so we
      # explicitly change it to `nil` to avoid this.
      new_value = value == 'NULL' ? nil : value
      new_row.merge(key => new_value)
    end
    cleaned_row.select { |k, _v| k.present? }.transform_keys(&:underscore)
  end

  private def sampled_row?(row_index)
    return true unless @only_random_subset
    @sampled_rows.include?(row_index)
  end

  private def import_filepath
    Rails.root.join('db/seeds/base/products.csv')
  end

  private def total_count
    11_027
  end
end
