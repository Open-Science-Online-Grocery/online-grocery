# frozen_string_literal: true

module Seeds
  module Development
    module Tags
      def self.seed_tags
        names = [
          'Custom Category 1',
          'Custom Category 2',
          'Custom Category 3'
        ]

        names.each do |name|
          Tag.find_or_create_by!(name: name)
        end
      end
    end
  end
end
