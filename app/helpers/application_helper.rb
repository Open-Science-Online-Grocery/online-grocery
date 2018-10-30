# frozen_string_literal: true

# :nodoc:
module ApplicationHelper
  def application_version
    version = "#{APP_VERSION[:major]}.#{APP_VERSION[:minor]}." \
      "#{APP_VERSION[:revision]}"
    if APP_VERSION[:release_candidate].present?
      version += ".rc-#{APP_VERSION[:release_candidate]}"
    end
    version
  rescue NoMethodError
    ''
  end
end
