# frozen_string_literal: true

FactoryBot.define do
  factory :subtag do
    tag
    sequence(:name) { |n| "Subtag #{n}" }
  end
end
