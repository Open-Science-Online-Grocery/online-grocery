# frozen_string_literal: true

# this controller is taking a roundabout way to build/deliver a file so that
# the "Download Product Data" button can be disabled on click while the large
# file is prepared and then re-enabled when the redirect to `show`
# is detected and the file is delivered.
class ProductDownloadsController < ApplicationController
  power :no_fallback, context: :set_condition, map: {
    %i[custom_categories suggestions sorting show] => :manageable_condition
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

  def sorting
    redirect_to_download(
      SortingCsvManager,
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
    tempfile = Tempfile.new(filename)
    tempfile.write(csv_generator_class.generate_csv(@condition))
    url = condition_product_download_path(
      @condition,
      filepath: tempfile.path,
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
