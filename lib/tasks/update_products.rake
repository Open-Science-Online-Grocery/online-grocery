# frozen_string_literal: true

task update_products: :environment do
  ProductImporter.new.import
  puts 'Success!'
end
