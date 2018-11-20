# frozen_string_literal: true

def clean_with_deletion
  DatabaseCleaner.clean_with(:deletion, except: database_views)
end

def database_views
  database = ActiveRecord::Base.connection_config[:database]
  ActiveRecord::Base.connection.execute(
    <<~SQL
      SELECT TABLE_NAME
      FROM information_schema.TABLES
      WHERE TABLE_TYPE = 'VIEW'
      AND TABLE_SCHEMA = '#{database}'
    SQL
  ).to_a.flatten
end
