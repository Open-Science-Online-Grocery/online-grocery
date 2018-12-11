# frozen_string_literal: true

require 'csv'

class ProductImporter
  def initialize(only_random_subset = false)
    @only_random_subset = only_random_subset
    @sampled_rows = (1..total_count).to_a.sample(1000)
  end

  def import
    csv = Rails.root.join('db', 'seeds', 'base', 'products.csv')
    i = 0
    CSV.foreach(csv, headers: true) do |row|
      i += 1
      import_row(row) if sampled_row?(i)
      puts "seeded product #{i} of #{total_count}" if i % 1000 == 0
    end
  end

  private def import_row(row)
    return unless row['id']
    product_attrs = row.to_h.except(
      'id',
      'category',
      'subcategory',
      'newcategory',
      'newsubcategory',
      'newsubsubid'
    ).select { |k, v| k.present? }
    product_attrs.transform_keys! { |key| key.underscore }

    category = Category.find_by(id: row['newcategory'])

    unless category
      puts "#{row['id']}, #{row['name']}"
      return
    end

    subcategory = category.subcategories.find_by(
      display_order: row['newsubcategory']
    )
    subsubcategory = subcategory.subsubcategories.find_by(
      display_order: row['newsubsubid']
    )

    product_attrs['original_id'] = row['id']
    product_attrs['category_id'] = category.id
    product_attrs['subcategory_id'] = subcategory.id
    product_attrs['subsubcategory_id'] = subsubcategory.try(:id)

    Product.create!(product_attrs)
  end

  private def sampled_row?(i)
    return true unless @only_random_subset
    @sampled_rows.include?(i)
  end

  private def total_count
    11027
  end
end
