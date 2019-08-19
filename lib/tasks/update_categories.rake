# frozen_string_literal: true

task update_categories: :environment do
  CategoryImporter.new.import
  puts 'Success!'
end
