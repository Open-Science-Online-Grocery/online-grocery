# frozen_string_literal: true

FactoryBot.define do
  factory :condition_label do
    condition
    label
    equation_tokens { [].to_json }
  end
end
