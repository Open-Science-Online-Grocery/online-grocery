# frozen_string_literal: true

FactoryBot.define do
  factory :custom_sorting do
    condition
    product
    sort_file
    sequence(:sort_order)
    sequence(:session_identifier) { |n| "SID #{n}" }
  end
end
