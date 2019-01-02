# frozen_string_literal: true

module Seeds
  module Base
    module ProductSortFields
      def self.seed_product_sort_fields
        sort_fields = ProductVariable.all + [
          { description: 'Name', attribute: :name },
          { description: 'Custom label', attribute: :label_image_url }
        ]
        sort_fields.each do |sort_field|
          ProductSortField.find_or_create_by!(
            description: sort_field[:description],
            name: sort_field[:attribute]
          )
        end
      end
    end
  end
end
