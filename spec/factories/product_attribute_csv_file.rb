# frozen_string_literal: true

FactoryBot.define do
  factory :product_attribute_csv_file do
    condition
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/product_attribute/good.csv')) }
  end
end
