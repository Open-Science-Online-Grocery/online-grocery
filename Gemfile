source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'aws-sdk-s3'
gem 'bcrypt_pbkdf'
gem 'bootsnap', require: false
gem 'carrierwave'
gem 'cocoon'
gem 'consul'
gem 'dentaku'
gem 'devise'
gem 'dkim'
gem 'ed25519'
gem 'fog-aws'
gem 'faraday'
gem 'jbuilder'
gem 'mysql2'
gem 'puma'
gem 'rails'
gem 'rake'
gem 'sass-rails'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier'
gem 'webpacker'

group :development, :test do
  gem 'awesome_print'
  gem 'bundler-audit'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-nav'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-performance', require: false
  gem 'webdrivers'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-maintenance', require: false
  gem 'capistrano-passenger'
  gem 'capistrano-rbenv'
  gem 'capistrano-rails'
  gem 'git_rails_tagger', git: 'https://gitlab.com/scimed-public/git-rails-tagger.git'
  gem 'letter_opener'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'headless'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

