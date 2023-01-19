# frozen_string_literal: true

FactoryBot.define do
  factory :custom_product_attribute do
    condition
    product
    product_attribute_csv_file
    custom_attribute_amount { 0 }
  end
end
