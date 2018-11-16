# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    sequence(:name) { |n| "Label #{n}" }
    image { File.open('spec/support/apple_icon.png') }
  end
end
