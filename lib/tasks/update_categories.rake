# frozen_string_literal: true

desc 'Update the system categories'
task update_categories: :environment do
  CategoryImporter.new.import
  puts 'Success!'
end
