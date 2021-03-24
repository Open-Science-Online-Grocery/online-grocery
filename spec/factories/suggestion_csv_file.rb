# frozen_string_literal: true

FactoryBot.define do
  factory :suggestion_csv_file do
    condition
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/suggestions/good_1.csv')) }
  end
end
