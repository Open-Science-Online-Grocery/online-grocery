# frozen_string_literal: true

module Seeds
  module Base
    module Categories
      def self.seed_categories
        names = [
          'Produce',
          'Meat, Dairy & Eggs',
          'Bakery, Pasta & Grains',
          'Dry Goods, Breakfast & Spices',
          'Pantry',
          'Canned',
          'Snacks',
          'Beverages',
          'Frozen Foods'
        ]
        names.each do |name|
          Category.find_or_create_by!(name: name)
        end
      end
    end
  end
end
