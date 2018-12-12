# frozen_string_literal: true

module Seeds
  module Base
    module Subcategories
      def self.seed_subcategories
        attrs = [
          { category_name: 'Produce', display_order: 1, name: 'Fresh Fruit' },
          { category_name: 'Produce', display_order: 2, name: 'Fresh Vegetables' },
          { category_name: 'Produce', display_order: 3, name: 'Packaged Produce' },
          { category_name: 'Produce', display_order: 4, name: 'Fresh Herbs' },
          { category_name: 'Produce', display_order: 5, name: 'Tofu & Meat Alternatives' },

          { category_name: 'Meat, Dairy & Eggs', display_order: 1, name: 'Dairy & Eggs' },
          { category_name: 'Meat, Dairy & Eggs', display_order: 2, name: 'Meat' },

          { category_name: 'Bakery, Pasta & Grains', display_order: 1, name: 'Bakery' },
          { category_name: 'Bakery, Pasta & Grains', display_order: 2, name: 'Pasta and Grains' },

          { category_name: 'Dry Goods, Breakfast & Spices', display_order: 1, name: 'Coffee, Tea & Creamers' },
          { category_name: 'Dry Goods, Breakfast & Spices', display_order: 2, name: 'Breakfast Items' },
          { category_name: 'Dry Goods, Breakfast & Spices', display_order: 3, name: 'Spices' },
          { category_name: 'Dry Goods, Breakfast & Spices', display_order: 4, name: 'Dried Beans' },
          { category_name: 'Dry Goods, Breakfast & Spices', display_order: 5, name: 'Ice Cream Cones & Topping' },
          { category_name: 'Dry Goods, Breakfast & Spices', display_order: 6, name: 'Instant Foods' },
          { category_name: 'Dry Goods, Breakfast & Spices', display_order: 7, name: 'Baking' },

          { category_name: 'Pantry', display_order: 1, name: 'Condiments & Spreads' },
          { category_name: 'Pantry', display_order: 2, name: 'Salad Dressing' },
          { category_name: 'Pantry', display_order: 3, name: 'Pickled Goods & Olives' },
          { category_name: 'Pantry', display_order: 4, name: 'International' },
          { category_name: 'Pantry', display_order: 5, name: 'Marinades & Sauces' },
          { category_name: 'Pantry', display_order: 6, name: 'Oils & Vinegar' },
          { category_name: 'Pantry', display_order: 7, name: 'Condensed Milk' },

          { category_name: 'Canned', display_order: 1, name: 'Canned Meats' },
          { category_name: 'Canned', display_order: 2, name: 'Canned Vegetables' },
          { category_name: 'Canned', display_order: 3, name: 'Soups & Pastas' },
          { category_name: 'Canned', display_order: 4, name: 'Canned Fruits & Apple Sauce' },

          { category_name: 'Snacks', display_order: 1, name: 'Crackers' },
          { category_name: 'Snacks', display_order: 2, name: 'Candy, Gum & Mints' },
          { category_name: 'Snacks', display_order: 3, name: 'Cookies' },
          { category_name: 'Snacks', display_order: 4, name: 'Chips, Pretzels & Rice Cakes' },
          { category_name: 'Snacks', display_order: 5, name: 'Dried Fruit & Nuts' },
          { category_name: 'Snacks', display_order: 6, name: 'Popcorn' },
          { category_name: 'Snacks', display_order: 7, name: 'Salsa & Dips' },

          { category_name: 'Beverages', display_order: 1, name: 'Bottled Tea' },
          { category_name: 'Beverages', display_order: 2, name: 'Energy Drinks' },
          { category_name: 'Beverages', display_order: 3, name: 'Flavored & Sparkling Water' },
          { category_name: 'Beverages', display_order: 4, name: 'Juice & Nectar' },
          { category_name: 'Beverages', display_order: 5, name: 'Powdered Drinks' },
          { category_name: 'Beverages', display_order: 6, name: 'Soda' },
          { category_name: 'Beverages', display_order: 7, name: 'Sport Drinks' },
          { category_name: 'Beverages', display_order: 8, name: 'Water' },

          { category_name: 'Frozen Foods', display_order: 1, name: 'Frozen Bread' },
          { category_name: 'Frozen Foods', display_order: 2, name: 'Breakfast' },
          { category_name: 'Frozen Foods', display_order: 3, name: 'Seafood' },
          { category_name: 'Frozen Foods', display_order: 4, name: 'Entrées' },
          { category_name: 'Frozen Foods', display_order: 5, name: 'Juice & Beverage' },
          { category_name: 'Frozen Foods', display_order: 6, name: 'Fruit' },
          { category_name: 'Frozen Foods', display_order: 7, name: 'Vegetables' },
          { category_name: 'Frozen Foods', display_order: 8, name: 'Snacks' },
          { category_name: 'Frozen Foods', display_order: 9, name: 'Dessert' }
        ]
        attrs.each do |attributes|
          category = Category.find_by(name: attributes[:category_name])
          Subcategory.find_or_create_by!(
            attributes.except(:category_name).merge(category_id: category.id)
          )
        end
      end
    end
  end
end
