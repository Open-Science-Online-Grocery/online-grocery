source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.2'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'jbuilder', '~> 2.5'
gem 'mysql2'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.1'
gem 'rake'
gem 'sass-rails', '~> 5.0'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

group :development, :test do
  gem 'bundler-audit'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-nav'
  # gem 'rspec-instafail'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'git_rails_tagger', git: 'git@git.scimedsolutions.com:scimed/git_rails_tagger.git'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
end

