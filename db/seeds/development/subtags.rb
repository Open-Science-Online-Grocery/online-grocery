# frozen_string_literal: true

module Seeds
  module Development
    module Subtags
      def self.seed_subtags
        attrs = [
          { tag_name: 'Custom Category 1', name: 'Custom Subcategory 1A' },
          { tag_name: 'Custom Category 1', name: 'Custom Subcategory 1B' },
          { tag_name: 'Custom Category 1', name: 'Custom Subcategory 1C' },
          { tag_name: 'Custom Category 2', name: 'Custom Subcategory 2A' },
          { tag_name: 'Custom Category 2', name: 'Custom Subcategory 2B' },
          { tag_name: 'Custom Category 2', name: 'Custom Subcategory 2C' },
          { tag_name: 'Custom Category 3', name: 'Custom Subcategory 3A' },
          { tag_name: 'Custom Category 3', name: 'Custom Subcategory 3B' },
          { tag_name: 'Custom Category 3', name: 'Custom Subcategory 3C' }
        ]

        attrs.each do |attributes|
          tag = Tag.find_by(name: attributes[:tag_name])
          Subtag.find_or_create_by!(name: attributes[:name], tag_id: tag.id)
        end
      end
    end
  end
end
