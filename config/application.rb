require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HowesGroceryResearcherPortal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # by default, Rails wraps the label and input tags of form fields
    # with errors in a div with class 'field-with-errors'. the div
    # wrapper breaks Semantic UI's 'required' class. the proc below
    # prevents the div wrapper.
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      html_tag
    }

    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.active_record.schema_format = :sql

    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = :local
  end
end
