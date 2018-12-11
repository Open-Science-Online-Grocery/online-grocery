# frozen_string_literal: true

module Seeds
  module Base
    module Subsubcategories
      def self.seed_subsubcategories
        attrs = [
          { subcategory_name: 'Packaged Produce', display_order: 1, name: 'Packaged Fruit' },
          { subcategory_name: 'Packaged Produce', display_order: 2, name: 'Packaged Veg' },
          { subcategory_name: 'Packaged Produce', display_order: 3, name: 'Dips and Spreads' },
          { subcategory_name: 'Packaged Produce', display_order: 4, name: 'Fruit Juice & Smoothie' },

          { subcategory_name: 'Dairy & Eggs', display_order: 1, name: 'Cheese' },
          { subcategory_name: 'Dairy & Eggs', display_order: 2, name: 'Yogurt' },
          { subcategory_name: 'Dairy & Eggs', display_order: 3, name: 'Milk' },
          { subcategory_name: 'Dairy & Eggs', display_order: 4, name: 'Cream' },
          { subcategory_name: 'Dairy & Eggs', display_order: 6, name: 'Eggs' },
          { subcategory_name: 'Dairy & Eggs', display_order: 7, name: 'Butter' },
          { subcategory_name: 'Dairy & Eggs', display_order: 8, name: 'Spreads' },
          { subcategory_name: 'Dairy & Eggs', display_order: 9, name: 'Vegan and Lactose-Free' },
          { subcategory_name: 'Dairy & Eggs', display_order: 10, name: 'Dessert' },

          { subcategory_name: 'Meat', display_order: 1, name: 'Prepared' },
          { subcategory_name: 'Meat', display_order: 2, name: 'Cured (Deli & Sausage)' },
          { subcategory_name: 'Meat', display_order: 3, name: 'Fresh Seafood' },
          { subcategory_name: 'Meat', display_order: 4, name: 'Fresh Poultry' },
          { subcategory_name: 'Meat', display_order: 5, name: 'Red Meat' },

          { subcategory_name: 'Bakery', display_order: 1, name: 'Bread' },
          { subcategory_name: 'Bakery', display_order: 2, name: 'Tortillas & Flatbread' },
          { subcategory_name: 'Bakery', display_order: 3, name: 'Buns & Rolls' },
          { subcategory_name: 'Bakery', display_order: 4, name: 'Breakfast Bakery' },
          { subcategory_name: 'Bakery', display_order: 5, name: 'Desserts' },

          { subcategory_name: 'Pasta and Grains', display_order: 1, name: 'Pasta' },
          { subcategory_name: 'Pasta and Grains', display_order: 2, name: 'Rice' },
          { subcategory_name: 'Pasta and Grains', display_order: 3, name: 'Other Grains' },

          { subcategory_name: 'Breakfast Items', display_order: 1, name: 'Cereal' },
          { subcategory_name: 'Breakfast Items', display_order: 2, name: 'Hot Cereal' },
          { subcategory_name: 'Breakfast Items', display_order: 3, name: 'Pancakes' },
          { subcategory_name: 'Breakfast Items', display_order: 4, name: 'Bars & Pastry' },

          { subcategory_name: 'Baking', display_order: 1, name: 'Cake, Muffin Mixes & Frosting' },
          { subcategory_name: 'Baking', display_order: 2, name: 'Cake Decorations' },
          { subcategory_name: 'Baking', display_order: 3, name: 'Brownie & Cookie Mixes' },
          { subcategory_name: 'Baking', display_order: 4, name: 'Chips, Morsels & Nuts' },
          { subcategory_name: 'Baking', display_order: 5, name: 'Flour, Meal & Coatings' },
          { subcategory_name: 'Baking', display_order: 6, name: 'Gelatins & Puddings' },
          { subcategory_name: 'Baking', display_order: 7, name: 'Pie Filling and Crust' },
          { subcategory_name: 'Baking', display_order: 8, name: 'Sugar & Sugar Substitutes' },

          { subcategory_name: 'Condiments & Spreads', display_order: 1, name: 'Honey, Syrup & Nectar' },
          { subcategory_name: 'Condiments & Spreads', display_order: 2, name: 'Ketchups & BBQ Sauce' },
          { subcategory_name: 'Condiments & Spreads', display_order: 3, name: 'Non-dairy Spreads' },
          { subcategory_name: 'Condiments & Spreads', display_order: 4, name: 'Mustard & Mayo' },

          { subcategory_name: 'International', display_order: 1, name: 'Asian' },
          { subcategory_name: 'International', display_order: 2, name: 'British' },
          { subcategory_name: 'International', display_order: 3, name: 'Kosher' },
          { subcategory_name: 'International', display_order: 4, name: 'Mexican' },
          { subcategory_name: 'International', display_order: 5, name: 'South Asian' },

          { subcategory_name: 'Marinades & Sauces', display_order: 1, name: 'Pasta Sauce' },
          { subcategory_name: 'Marinades & Sauces', display_order: 2, name: 'Specialty Sauce' },
          { subcategory_name: 'Marinades & Sauces', display_order: 3, name: 'Marinades' },

          { subcategory_name: 'Canned Vegetables', display_order: 1, name: 'Beans' },
          { subcategory_name: 'Canned Vegetables', display_order: 2, name: 'Tomatoes' },
          { subcategory_name: 'Canned Vegetables', display_order: 3, name: 'Vegetables' },

          { subcategory_name: 'Soups & Pastas', display_order: 1, name: 'Broth, Bouillon, & Sauces' },
          { subcategory_name: 'Soups & Pastas', display_order: 2, name: 'Condensed Soup' },
          { subcategory_name: 'Soups & Pastas', display_order: 3, name: 'Instant Soup Mix' },
          { subcategory_name: 'Soups & Pastas', display_order: 4, name: 'Ready to Eat Soup' },

          { subcategory_name: 'Chips, Pretzels & Rice Cakes', display_order: 1, name: 'Rice Cakes' },
          { subcategory_name: 'Chips, Pretzels & Rice Cakes', display_order: 2, name: 'Pretzels' },
          { subcategory_name: 'Chips, Pretzels & Rice Cakes', display_order: 3, name: 'Chips, Curls, & Puffs' },

          { subcategory_name: 'Frozen Bread', display_order: 1, name: 'Biscuits & Bagels' },
          { subcategory_name: 'Frozen Bread', display_order: 2, name: 'Buns & Rolls' },
          { subcategory_name: 'Frozen Bread', display_order: 3, name: 'Garlic Bread' },

          { subcategory_name: 'Entrées', display_order: 1, name: 'Asian Entrées' },
          { subcategory_name: 'Entrées', display_order: 2, name: 'Hispanic' },
          { subcategory_name: 'Entrées', display_order: 3, name: 'Kosher Entrées' },
          { subcategory_name: 'Entrées', display_order: 4, name: 'Frozen Dinner' },
          { subcategory_name: 'Entrées', display_order: 5, name: 'Pot Pie' },
          { subcategory_name: 'Entrées', display_order: 6, name: 'Meatless' },
          { subcategory_name: 'Entrées', display_order: 7, name: 'Frozen Pastas' },
          { subcategory_name: 'Entrées', display_order: 8, name: 'Frozen Pizza' },

          { subcategory_name: 'Vegetables', display_order: 1, name: 'Potatoes' },
          { subcategory_name: 'Vegetables', display_order: 2, name: 'Other Veggies' },

          { subcategory_name: 'Dessert', display_order: 1, name: 'Cakes, Pies & Desserts' },
          { subcategory_name: 'Dessert', display_order: 2, name: 'Toppings' },
          { subcategory_name: 'Dessert', display_order: 3, name: 'Ice Cream' },
          { subcategory_name: 'Dessert', display_order: 4, name: 'Frozen Novelties' }
        ]
        attrs.each do |attributes|
          subcategory = Subcategory.find_by(name: attributes[:subcategory_name])
          Subsubcategory.find_or_create_by!(
            attributes.except(:subcategory_name).merge(subcategory_id: subcategory.id)
          )
        end
      end
    end
  end
end
