# frozen_string_literal: true

FactoryBot.define do
  factory :subcategory do
    category
    sequence(:name) { |n| "Subcategory #{n}" }
  end
end
