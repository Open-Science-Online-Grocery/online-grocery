# frozen_string_literal: true

# Presenter to give access to download links for ConfigFiles
class ConfigFilePresenter
  extend ActionView::Helpers::UrlHelper
  extend ActionView::Helpers::TagHelper
  extend ActionView::Context

  def self.download_link(config_file)
    link_to(
      tag.i(class: 'large download icon') + config_file.name,
      Rails.application.routes.url_helpers.config_file_path(config_file)
    )
  end
end
