# frozen_string_literal: true

task update_product_aws_image_urls: :environment do
  ProductUrlManager.new.update_aws_image_urls
end
