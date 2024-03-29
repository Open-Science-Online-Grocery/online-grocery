# frozen_string_literal: true

load './lib/scripts/product_exporter.rb'

desc 'Updates all the products'
task update_products: :environment do
  ProductImporter.new.import
  if Product.where(aws_image_url: nil).any?
    ProductUrlManager.new.convert_to_s3
    ProductExporter.new.run(Rails.root.join('db/seeds/base/products.csv'))
  end

  puts 'Success!'
end
