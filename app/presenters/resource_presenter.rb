# frozen_string_literal: true

# Presenter to give access to download links for files stored by the system.
# Can wrap any class that responds to #path and #name for the location and name
# of the file to be downloaded. Example: see TagCsvFile
class ResourcePresenter < SimpleDelegator
  include ActionView::Helpers::UrlHelper
  include ActionView::Context

  alias resource __getobj__

  def download_link(size = 'large')
    link_to(download_path) do
      content_tag(:i, '', class: "#{size} download icon") + name
    end
  end

  private def download_path
    Rails.application.routes.url_helpers.resource_download_path(
      resource,
      resource_type: resource.class
    )
  end
end
