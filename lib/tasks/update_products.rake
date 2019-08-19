# frozen_string_literal: true

load './lib/scripts/product_exporter.rb'

task update_products: :environment do
  ProductImporter.new.import
  if Product.where(aws_image_url: nil).any?
    ProductUrlManager.new.convert_to_s3
    ProductExporter.new.run
  end

  puts 'Success!'
end
