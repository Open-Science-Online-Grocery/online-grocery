# frozen_string_literal: true

require 'csv'

module Seeds
  module Base
    module Products
      def self.seed_products
        return if Product.any?
        importer = ProductImporter.new(ENV['SHORT_SEED'] == '1')
        importer.import
      end
    end
  end
end
