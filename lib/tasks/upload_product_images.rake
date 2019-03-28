# frozen_string_literal: true

task upload_product_images: :environment do
  ProductUrlManager.new.convert_to_s3
end
