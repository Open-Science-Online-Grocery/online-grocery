# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require_relative 'lib/tasks/structure_fixer.rb'

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

  task default: [:spec, :rubocop, :eslint, :bundler_audit]
end

task('db:migrate' => ['db:drop_views']).enhance do
  Rake::Task['db:create_views'].invoke
  if Rails.application.config.active_record.schema_format == :sql && Rails.env.development?
    Rake::Task["db:structure:dump"].invoke
    StructureFixer.run
  end
end

task('db:rollback' => ['db:drop_views']).enhance do
  Rake::Task['db:create_views'].invoke
  if Rails.application.config.active_record.schema_format == :sql && Rails.env.development?
    Rake::Task["db:structure:dump"].invoke
    StructureFixer.run
  end
end
