# frozen_string_literal: true

module Seeds
  module Base
    module ProductSortFields
      def self.seed_product_sort_fields
        ProductVariable.all.each do |variable|
          ProductSortField.find_or_create_by!(
            description: variable.description,
            name: variable.attribute
          )
        end

        additional_sort_fields = [
          { description: 'Name', name: :name },
          { description: 'Custom label', name: :label_sort }
        ]
        additional_sort_fields.each do |sort_field|
          ProductSortField.find_or_create_by!(
            description: sort_field[:description],
            name: sort_field[:name]
          )
        end
      end
    end
  end
end
