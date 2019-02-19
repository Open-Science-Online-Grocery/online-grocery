# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
require 'rspec/rails'

require 'capybara/rails'
require 'headless'
require 'selenium-webdriver'
require 'database_cleaner'
require 'factory_bot'
require 'shoulda-matchers'
require 'capybara-screenshot/rspec'
require 'chromedriver-helper' unless ENV['TEST_ENVIRONMENT'] == 'CI'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

FactoryBot.use_parent_strategy = true

# Include all shared examples and other files in the spec/support directory.
Dir['./spec/**/support/**/*.rb'].sort.each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# Raise logging level for performance
Rails.logger.level = 4

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :feature

  config.include FactoryBot::Syntax::Methods

  config.include CapybaraAddons

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # this variable is set here: https://gitlab.com/scimedsolutions/CCFH/ebt_pop/settings/ci_cd
  Capybara.default_max_wait_time = 30 if ENV['TEST_ENVIRONMENT'] == 'CI'
  Capybara::Screenshot.prune_strategy = { keep: 20 }

  # `clean_with_deletion` is defined in spec/support/database_cleaner_helper
  config.before(:suite) { clean_with_deletion }

  config.before do |example|
    if example.metadata[:js]
      # `database_views` is defined in spec/support/database_cleaner_helper
      DatabaseCleaner.strategy = :deletion, { except: database_views }
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
  end

  config.append_after { DatabaseCleaner.clean }

  # this variable is set here: https://gitlab.com/scimedsolutions/HowesGrocery/howes_grocery_researcher_portal/settings/ci_cd
  if ENV['TEST_ENVIRONMENT'] == 'CI'
    Capybara.default_max_wait_time = 30

    Capybara::Screenshot.s3_configuration = {
      s3_client_credentials: {
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      },
      bucket_name: 'com-scimed-gitlab-ci-screenshots',
      key_prefix: 'howes_grocery_researcher_portal/'
    }
  end
  Capybara::Screenshot.prune_strategy = { keep: 20 }

  Capybara.register_driver :selenium_chrome_headless do |app|
    browser_options = ::Selenium::WebDriver::Chrome::Options.new
    if ENV['BROWSER']
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome
    else
      browser_options.args << '--headless'
      browser_options.args << '--disable-gpu'
      browser_options.args << '--no-sandbox'
      browser_options.args << '--window-size=1440,900'
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        acceptInsecureCerts: true
      )
    end
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 240 # instead of the default 60
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: browser_options,
      desired_capabilities: capabilities,
      http_client: client
    )
  end

  Capybara.javascript_driver = :selenium_chrome_headless
  Capybara.ignore_hidden_elements = false
end
