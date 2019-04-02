# frozen_string_literal: true

# Presenter to give access to download links for TagCsvFiles.
class TagCsvFilePresenter < SimpleDelegator
  include ActionView::Helpers::UrlHelper
  include ActionView::Context

  alias tag_csv_file __getobj__

  def download_link(size = 'large')
    link_to(download_path) do
      content_tag(:i, '', class: "#{size} download icon") + name
    end
  end

  private def download_path
    Rails.application
      .routes
      .url_helpers
      .tag_csv_file_path(tag_csv_file)
  end
end
