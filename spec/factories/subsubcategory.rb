# frozen_string_literal: true

FactoryBot.define do
  factory :subsubcategory do
    subcategory
    sequence(:name) { |n| "Subsubcategory #{n}" }
  end
end
