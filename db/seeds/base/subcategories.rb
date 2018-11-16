# frozen_string_literal: true

module Seeds
  module Base
    module Subcategories
      def self.seed_subcategories
        attrs = [
          { category_name: 'Packaged & Canned', display_order: 4, name: 'Baking Products' },
          { category_name: 'Bread, Pasta & Rice', display_order: 1, name: 'Bread' },
          { category_name: 'Packaged & Canned', display_order: 5, name: 'Canned Goods' },
          { category_name: 'Packaged & Canned', display_order: 1, name: 'Cereal, Oatmeal, Granola & More' },
          { category_name: 'Dairy, Deli, Milk & Meat', display_order: 2, name: 'Cheese' },
          { category_name: 'Dairy, Deli, Milk & Meat', display_order: 6, name: 'Cheese & Meat Alternatives' },
          { category_name: 'Packaged & Canned', display_order: 6, name: 'Coffee & Tea' },
          { category_name: 'Condiments, Spreads & Sauces', display_order: 1, name: 'Condiments & Sauces' },
          { category_name: 'Packaged & Canned', display_order: 3, name: 'Cookies, Candy & Gum' },
          { category_name: 'Packaged & Canned', display_order: 2, name: 'Crackers, Nuts & Chips' },
          { category_name: 'Beverages', display_order: 4, name: 'Drink Mix' },
          { category_name: 'Dairy, Deli, Milk & Meat', display_order: 3, name: 'Eggs' },
          { category_name: 'Frozen Foods', display_order: 2, name: 'Frozen Fruits & Veggies' },
          { category_name: 'Frozen Foods', display_order: 1, name: 'Frozen Meals' },
          { category_name: 'Produce', display_order: 1, name: 'Fruits' },
          { category_name: 'Produce', display_order: 3, name: 'Herbs' },
          { category_name: 'Frozen Foods', display_order: 3, name: 'Ice Cream & Desserts' },
          { category_name: 'Packaged & Canned', display_order: 8, name: 'International Foods' },
          { category_name: 'Beverages', display_order: 3, name: 'Juice & Teas' },
          { category_name: 'Dairy, Deli, Milk & Meat', display_order: 4, name: 'Meat' },
          { category_name: 'Dairy, Deli, Milk & Meat', display_order: 1, name: 'Milk & Cream' },
          { category_name: 'Condiments, Spreads & Sauces', display_order: 2, name: 'Nut Butter, Jelly & More' },
          { category_name: 'Frozen Foods', display_order: 4, name: 'Other Frozen Goods' },
          { category_name: 'Packaged & Canned', display_order: 7, name: 'Other Packaged Food' },
          { category_name: 'Bread, Pasta & Rice', display_order: 3, name: 'Pasta, Rice & Tortillas' },
          { category_name: 'Bread, Pasta & Rice', display_order: 2, name: 'Rolls, Buns, Bagels & Donuts' },
          { category_name: 'Beverages', display_order: 2, name: 'Soda, Sport & Energy Drinks' },
          { category_name: 'Beverages', display_order: 1, name: 'Sparkling, Still & Flavored Water' },
          { category_name: 'Condiments, Spreads & Sauces', display_order: 3, name: 'Spices' },
          { category_name: 'Produce', display_order: 2, name: 'Vegetables' },
          { category_name: 'Dairy, Deli, Milk & Meat', display_order: 5, name: 'Yogurt' }
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
