# frozen_string_literal: true

# this controller is taking a roundabout way to build/deliver a file so that
# the "Download Product Data" button can be disabled on click while the large
# file is prepared and then re-enabled when the redirect to `show`
# is detected and the file is delivered.
class ProductDownloadsController < ApplicationController
  power :products, map: {
    %i[custom_categories suggestions show] => :downloadable_products
  }

  def custom_categories
    redirect_to_download(
      CustomCategoryCsvManager,
      'product_categories_data.csv'
    )
  end

  def suggestions
    redirect_to_download(
      SuggestionsCsvManager,
      'product_suggestion_data.csv'
    )
  end

  private def redirect_to_download(csv_generator_class, filename)
    tempfile = Tempfile.new(filename)
    tempfile.write(csv_generator_class.generate_csv)
    url = product_download_path(filepath: tempfile.path, filename: filename)
    respond_to do |format|
      format.js do
        render js: "window.location.href = \"#{url}\";"
      end
    end
  end

  def show
    send_file(
      params[:filepath],
      disposition: 'attachment',
      filename: params[:filename]
    )
  end
end
