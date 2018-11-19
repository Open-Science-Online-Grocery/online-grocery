# frozen_string_literal: true

require 'csv'

module Seeds
  module Base
    module Products
      # rubocop:disable Metrics/AbcSize
      def self.seed_products
        return if Product.any?
        category_ids_by_name = {}
        Category.find_each do |category|
          category_ids_by_name[category.name] = category.id
        end
        subcategory_ids_by_name = {}
        Subcategory.find_each do |subcategory|
          subcategory_ids_by_name[subcategory.name] = subcategory.id
        end

        sampled_ids = (2..14_534).to_a.sample(1000)
        csv = Rails.root.join('db', 'seeds', 'base', 'products.csv')
        CSV.foreach(csv, headers: true) do |row|
          next if ENV['SHORT_SEED'] == '1' && !row['id'].to_i.in?(sampled_ids)

          category_id = category_ids_by_name[row['category_name']]
          subcategory_id = subcategory_ids_by_name[row['subcategory_name']]

          product_attrs = row.to_h.except(
            'id',
            'category_name',
            'subcategory_name',
            'newcategory',
            'newsubid',
            'newsubsubid',
            'category',
            'subcategory'
          )
          Product.create!(
            product_attrs.merge(
              category_id: category_id,
              subcategory_id: subcategory_id
            )
          )
        end
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
