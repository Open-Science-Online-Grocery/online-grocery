# frozen_string_literal: true

require 'csv'

# responsible for importing product data from a spreadsheet. change the value
# returned by #total_count if the number of products in the spreadsheet changes.
class ProductImporter
  def initialize(only_random_subset = false)
    @only_random_subset = only_random_subset
    @sampled_rows = (1..total_count).to_a.sample(1000)
  end

  # rubocop:disable Rails/Output
  def import
    csv = Rails.root.join('db', 'seeds', 'base', 'products.csv')
    i = 0
    CSV.foreach(csv, headers: true) do |row|
      i += 1
      import_row(row) if sampled_row?(i)
      puts "seeded product #{i} of #{total_count}" if i % 1000 == 0
    end
  end
  # rubocop:enable Rails/Output

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  private def import_row(row)
    return unless row['id']
    cleaned_row = clean_row(row)
    product_attrs = cleaned_row.except(
      'category',
      'subcategory',
      'newcategory', # the ID of the product's Category
      'newsubcategory', # the display order of the product's Subcategory
      'newsubsubid' # the display order of the product's Subsubcategory
    ).select { |k, _v| k.present? }
    product_attrs.transform_keys!(&:underscore)

    category = Category.find_by(id: cleaned_row['newcategory'])
    subcategory = category.subcategories.find_by(
      display_order: cleaned_row['newsubcategory']
    )
    subsubcategory = subcategory.subsubcategories.find_by(
      display_order: cleaned_row['newsubsubid']
    )

    product_attrs['category_id'] = category.id
    product_attrs['subcategory_id'] = subcategory.id
    product_attrs['subsubcategory_id'] = subsubcategory.try(:id)

    product = Product.find_or_initialize_by(id: row['id'])
    product.update!(product_attrs)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private def clean_row(row)
    row.to_h.reduce({}) do |cleaned_row, (key, value)|
      # 'NULL' will be inappropriately cast to `0` for integer columns, so we
      # explicitly change it to `nil` to avoid this.
      new_value = value == 'NULL' ? nil : value
      cleaned_row.merge(key => new_value)
    end
  end

  private def sampled_row?(row_index)
    return true unless @only_random_subset
    @sampled_rows.include?(row_index)
  end

  private def total_count
    11_027
  end
end
