# frozen_string_literal: true

desc 'Uploads images for the products'
task upload_product_images: :environment do
  ProductUrlManager.new.convert_to_s3
end
