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

  def convert_to_s3
    copy_products_to_host
    upload_and_update
    clean_up_host
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

  private def copy_products_to_host
    Dir.mkdir(@local_tmp_images_path)
    products = Product.order(:id)

    products.find_each do |product|
      open(product_path(product.name), 'wb') do |file|
        file << open(product.image_src).read
      end
    end
  end

  private def upload_and_update
    ActiveRecord::Base.transaction do
      Dir.foreach(@local_tmp_images_path) do |file_name|
        next if %w[. ..].include?(file_name)

        original_product_name = unescape_slashes(file_name)
        product = Product.find_by(name: original_product_name)
        product_not_found_error(original_product_name) unless product.present?

        upload_product_image(file_name)
        update_product_record(
          product,
          @s3_bucket.object(file_name).public_url
        )
      end
    end
  end

  private def upload_product_image(product_name)
    @s3_client.put_object(
      bucket: @bucket_name,
      key: product_name,
      body: open(product_path(product_name)),
      acl: 'public-read'
    )
  end

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

  private def product_path(product_name)
    escaped_product_name = escape_slashes(product_name)
    Pathname.new("#{@local_tmp_images_path}/#{escaped_product_name}")
  end

  # These substitutions are done to avoid MacOS treating `/` characters
  # in product names as directory entries. We're substituting them for
  # `$` characters so we can keep track of them and change them back to
  # find products by name in order to update their `aws_image_url`s
  private def escape_slashes(string)
    string.tr('/', '$')
  end

  private def unescape_slashes(string)
    string.tr('$', '/')
  end

  private def product_not_found_error(name)
    puts "Product #{name} was not found."
    raise ActiveRecord::Rollback
  end

  private def product_update_failed_error(product)
    puts product.errors.full_messages.join(', ')
    raise ActiveRecord::Rollback
  end

  private def tmp_dir_too_big_error
    puts "Tmp directory #{@local_tmp_images_path} is too big, "\
      'please remove it manually.'
  end
end
