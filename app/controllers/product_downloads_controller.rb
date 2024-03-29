# frozen_string_literal: true

# this controller is taking a roundabout way to build/deliver a file so that
# the "Download Product Data" button can be disabled on click while the large
# file is prepared and then re-enabled when the redirect to `show`
# is detected and the file is delivered.
class ProductDownloadsController < ApplicationController
  power :no_fallback, context: :set_condition, map: {
    %i[
      custom_categories
      suggestions
      sorting
      show
      custom_product_attribute
      custom_product_prices
    ] => :manageable_condition
  }

  def custom_product_prices
    redirect_to_download(
      CsvFileManagers::ProductPrice,
      'product_price_data.csv'
    )
  end

  def custom_categories
    redirect_to_download(
      CsvFileManagers::Category,
      'product_categories_data.csv'
    )
  end

  def custom_product_attribute
    redirect_to_download(
      CsvFileManagers::ProductAttribute,
      'product_attribute_data.csv'
    )
  end

  def suggestions
    redirect_to_download(
      CsvFileManagers::Suggestion,
      'product_suggestion_data.csv'
    )
  end

  def sorting
    redirect_to_download(
      CsvFileManagers::Sorting,
      'product_sorting_data.csv'
    )
  end

  def show
    send_file(
      params[:filepath],
      disposition: 'attachment',
      filename: params[:filename]
    )
  end

  private def redirect_to_download(csv_generator_class, filename)
    filepath, filename = CsvFilesOrganizer.new(
      filename,
      csv_generator_class,
      @condition
    ).handle_csv_file

    url = condition_product_download_path(
      @condition,
      filepath: filepath,
      filename: filename
    )
    respond_to do |format|
      format.js do
        render js: "window.location.href = \"#{url}\";"
      end
    end
  end

  private def set_condition
    @condition = Condition.find(params[:condition_id])
  end
end
