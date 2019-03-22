# frozen_string_literal: true

require 'aws-sdk-s3'
require 'open-uri'

# responsible for uploading product records' images from the Publix website
# onto S3, and updating the records to reflect the new location of the image
# on S3. this class uses the local storage of the computer running the task
# temporarily to store the images to upload, and removes them once finished.
# These uploads look to be taking about 0.3 sec/image.
class ProductUrlManager
  def initialize
    set_up_local_env
    set_up_s3
  end

  # this method will use the image_src attribute of the products to download
  # all the images locally, upload them to S3, update the aws_image_url
  # attribute to reflect the location of the image on S3, then delete the local
  # copy of the images from the host computer.
  def convert_to_s3
    copy_products_to_host
    upload_and_update
    clean_up_host
  end

  # this method assumes that S3 already has all the images needed for the
  # products, and will only update the aws_image_url of each product to
  # match where it should be on S3.
  def update_aws_image_urls
    errors = []

    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback if errors.present?

      Product.order(:id).find_each do |product|
        # rubocop:disable Rails/SaveBang
        product.update(aws_image_url: "#{@aws_base_url}/#{product.id}")
        # rubocop:enable Rails/SaveBang
        errors << product.errors.full_messages if product.errors.present?
      end
    end

    print_errors(errors) if errors.present?
  end

  private def set_up_local_env
    # Adding a random prefix to make sure we won't
    # possibly clobber any existing directories
    random_prefix = SecureRandom.hex(10)
    @local_tmp_images_path = Rails.root.join(
      'tmp',
      "#{random_prefix}_howes_grocery_tmp_images"
    )
  end

  private def set_up_s3
    @aws_base_url = 'https://com-howes-grocery-product-images.s3.amazonaws.com'
    credentials = Aws::Credentials.new(
      Rails.application.credentials.dig(:aws_product_images, :access_key_id),
      Rails.application.credentials.dig(:aws_product_images, :secret_access_key)
    )

    @bucket_name =
      Rails.application.credentials.dig(:aws_product_images, :bucket)
    @s3_bucket = Aws::S3::Resource.new(
      region: 'us-east-1',
      credentials: credentials
    ).bucket(@bucket_name)

    @s3_client = Aws::S3::Client.new(
      region: 'us-east-1',
      credentials: credentials
    )
  end

  private def copy_products_to_host(starting_product_id = 0, retry_count = 0)
    Dir.mkdir(@local_tmp_images_path)
    importing_product_id = 0

    # rubocop:disable Security/Open
    products_greater_than(starting_product_id).find_each do |product|
      importing_product_id = product.id

      open(product_path(importing_product_id), 'wb') do |file|
        file << open(product.image_src).read
      end
    end
    # rubocop:enable Security/Open
  rescue Net::OpenTimeout
    return import_timeout_error if retry_count >= 3

    retry_count += 1
    retry_image_copy_message(importing_product_id, retry_count)
    copy_products_to_host(importing_product_id, retry_count)
  end

  private def upload_and_update
    ActiveRecord::Base.transaction do
      Dir.foreach(@local_tmp_images_path) do |product_id|
        next if %w[. ..].include?(product_id)

        product = Product.find(product_id)

        upload_product_image(product_id)
        update_product_record(
          product,
          @s3_bucket.object(product_id).public_url
        )
      end
    end
  end

  # rubocop:disable Security/Open
  private def upload_product_image(product_id)
    @s3_client.put_object(
      bucket: @bucket_name,
      key: product_id,
      body: open(product_path(product_id)),
      acl: 'public-read'
    )
  end
  # rubocop:enable Security/Open

  private def update_product_record(product, aws_image_url)
    update_success = product.update(aws_image_url: aws_image_url)
    product_update_failed_error(product) unless update_success
  end

  private def clean_up_host
    # calculate size of directory that will be deleted
    tmp_images_dir_size = Dir.glob(
      File.join(@local_tmp_images_path, '**', '*')
    ).map { |file| File.size(file) }.reduce(:+)

    # Extra check in place to make sure we don't accidentally delete something
    # bigger than we intended, just in case the file path got messed up somehow.
    # This will make sure we don't delete a directory bigger than 1 GB
    if tmp_images_dir_size < 1_000_000_000
      FileUtils.remove_dir(@local_tmp_images_path)
    else
      tmp_dir_too_big_error
    end
  end

  private def product_path(product_id)
    Pathname.new("#{@local_tmp_images_path}/#{product_id}")
  end

  private def products_greater_than(product_id)
    product_table = Product.arel_table
    Product.where(
      product_table[:id].gteq(product_id)
    )
  end

  # rubocop:disable Rails/Output
  private def product_update_failed_error(product)
    puts product.errors.full_messages.join(', ')
    raise ActiveRecord::Rollback
  end

  private def tmp_dir_too_big_error
    puts "Tmp directory #{@local_tmp_images_path} is too big, "\
      'please remove it manually.'
  end

  private def import_timeout_error
    puts 'Importing products to the local machine has timed out. Please try '\
      'again. The imported images so far can be found at '\
      "#{@local_tmp_images_path}"
  end

  private def retry_image_copy_message(starting_product_id, retry_count)
    puts 'Timeout occurred while copying images to local machine. '\
      "Retry #{retry_count}, starting at ID #{starting_product_id}."
  end

  private def print_errors(errors)
    puts 'Update failed.'
    puts errors.compact.join(', ')
  end
  # rubocop:enable Rails/Output
end
