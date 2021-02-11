# frozen_string_literal: true

FactoryBot.define do
  factory :product_suggestion do
    condition
    suggestion_csv_file
    product
    association :add_on_product, factory: :product
  end
end
