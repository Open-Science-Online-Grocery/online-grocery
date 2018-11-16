# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

if Rails.env.test? || Rails.env.development?
  require 'rspec/core/rake_task'

  task :rubocop do
    sh 'rubocop --fail-level convention'
  end

  task :eslint do
    sh 'yarn run eslint'
  end

  task :npm_audit do
    sh 'yarn audit'
  end

  task :bundler_audit do
    sh 'bundle audit'
  end

  task default: [:spec, :rubocop, :eslint, :bundler_audit, :npm_audit]
  task ci:      [:default]
end
