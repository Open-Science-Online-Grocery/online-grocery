# frozen_string_literal: true

module Seeds
  module Base
    module ProductSortFields
      def self.seed_product_sort_fields
        sort_fields = {
          'Calories from fat' => :caloriesFromFat,
          'Calories' => :calories,
          'Total fat' => :totalFat,
          'Saturated fat' => :saturatedFat,
          'Trans fat' => :transFat,
          'Cholesterol' => :cholesterol,
          'Sodium' => :sodium,
          'Total carbohydrates' => :carbs,
          'Dietary fiber' => :fiber,
          'Sugars' => :sugar,
          'Protein' => :protein,
          'Star points' => :starpoints,
          'Price' => :price,
          'Name' => :name,
          'Custom label' => :label_image_url
        }
        sort_fields.each do |description, name|
          ProductSortField.find_or_create_by!(
            description: description,
            name: name
          )
        end
      end
    end
  end
end
