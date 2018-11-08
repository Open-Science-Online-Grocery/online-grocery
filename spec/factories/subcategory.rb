# frozen_string_literal: true

FactoryBot.define do
  factory :subcategory do
    sequence(:name) { |n| "subcategory #{n}" }
  end
end
