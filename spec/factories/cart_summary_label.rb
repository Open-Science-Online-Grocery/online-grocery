# frozen_string_literal: true

FactoryBot.define do
  factory :cart_summary_label do
    sequence(:name) { |n| "Cart Summary Label #{n}" }
  end
end
