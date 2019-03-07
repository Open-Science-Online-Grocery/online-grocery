# frozen_string_literal: true

FactoryBot.define do
  factory :condition do
    sequence(:name) { |n| "Condition #{n}" }
    experiment
    uuid { SecureRandom.uuid }
    qualtrics_code { 'ABCDEFG' }
  end
end
