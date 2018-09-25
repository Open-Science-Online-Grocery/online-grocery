# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'rspec/core/rake_task'
require 'bundler/audit/task'

Rails.application.load_tasks

task :rubocop do
  sh 'rubocop --fail-level convention'
end

Bundler::Audit::Task.new

task default: [:spec, :rubocop, 'bundle:audit']
task ci:      [:spec, :rubocop, 'bundle:audit']