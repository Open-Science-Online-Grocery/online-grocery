# frozen_string_literal: true

FactoryBot.define do
  factory :experiment do
    sequence(:name) { |n| "Experiment #{n}" }
    user
  end
end
