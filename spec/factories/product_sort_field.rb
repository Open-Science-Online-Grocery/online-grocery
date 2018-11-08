# frozen_string_literal: true

FactoryBot.define do
  factory :product_sort_field do
    sequence(:name) { |n| "Sort Field #{n}" }
    sequence(:description) { |n| "Sort Field description #{n}" }
  end
end
