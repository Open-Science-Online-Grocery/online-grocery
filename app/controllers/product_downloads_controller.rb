# frozen_string_literal: true

# this controller is taking a roundabout way to build/deliver a file so that
# the "Download Product Data" button can be disabled on click while the large
# file is prepared (in `new`) and then re-enabled when the redirect to `show`
# is detected and the file is delivered.
class ProductDownloadsController < ApplicationController
  power :products, map: {
    %i[new show] => :downloadable_products
  }

  def new
    tempfile = Tempfile.new(filename)
    tempfile.write(ProductDataCsvManager.generate_csv)
    url = product_download_path(filepath: tempfile.path)
    respond_to do |format|
      format.js do
        render js: "window.location.href = \"#{url}\";"
      end
    end
  end

  def show
    send_file(params[:filepath], disposition: 'attachment', filename: filename)
  end

  private def filename
    'product_categories_data.csv'
  end
end
