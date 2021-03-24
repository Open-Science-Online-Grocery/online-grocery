# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require_relative 'lib/tasks/structure_fixer.rb'

Rails.application.load_tasks

if Rails.env.test? || Rails.env.development?
  require 'rspec/core/rake_task'

  task :js_tests do
    sh 'yarn test'
  end

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
    sh 'bundle audit --update'
  end

  # from https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#linting-factories
  desc 'Verify that all FactoryBot factories are valid'
  task factory_bot_lint: :environment do
    if Rails.env.test?
      conn = ActiveRecord::Base.connection
      conn.transaction do
        FactoryBot.lint
        raise ActiveRecord::Rollback
      end
    else
      system("bundle exec rake factory_bot_lint RAILS_ENV='test'")
      fail if $?.exitstatus.nonzero?
    end
  end

  task default: [:spec, :js_tests, :rubocop, :eslint, :factory_bot_lint, :bundler_audit]
  task ci:      [:default]
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
