# frozen_string_literal: true

module Seeds
  module Base
    module Categories
      def self.seed_categories
        names = [
          'Beverages',
          'Bread, Pasta & Rice',
          'Condiments, Spreads & Sauces',
          'Dairy, Deli, Milk & Meat',
          'Frozen Foods',
          'Packaged & Canned',
          'Produce'
        ]
        names.each do |name|
          Category.find_or_create_by!(name: name)
        end
      end
    end
  end
end
