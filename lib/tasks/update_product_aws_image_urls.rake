# frozen_string_literal: true

desc 'Updates the url for the product image on AWS'
task update_product_aws_image_urls: :environment do
  ProductUrlManager.new.update_aws_image_urls
end
