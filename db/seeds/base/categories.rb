# frozen_string_literal: true

module Seeds
  module Base
    module Categories
      def self.seed_categories
        return if Category.any?
        CategoryImporter.new.import
      end
    end
  end
end
