# frozen_string_literal: true

namespace :db do
  task create_views: :environment do
    sql_filepaths = Dir.glob('db/views/*.sql')
    sql_filepaths.each do |sql_filepath|
      view_name = File.basename(sql_filepath, '.sql')

      view_sql = File.read(sql_filepath)

      ActiveRecord::Base.connection.execute(view_sql)
      puts "Database view #{view_name} successfully created"
    end
  end

  task drop_views: :environment do
    database = ActiveRecord::Base.connection_config[:database]
    views = ActiveRecord::Base.connection.execute(
      <<~SQL
        SELECT TABLE_NAME
        FROM information_schema.TABLES
        WHERE TABLE_TYPE = 'VIEW'
        AND TABLE_SCHEMA = '#{database}'
      SQL
    )
    views = views.to_a.flatten
    views.each do |view_name|
      ActiveRecord::Base.connection.execute(
        "DROP VIEW IF EXISTS #{view_name}"
      )
      puts "Database #{view_name} successfully dropped"
    end
  end
end
