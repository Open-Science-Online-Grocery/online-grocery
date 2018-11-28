# frozen_string_literal: true

FactoryBot.define do
  factory :condition_cart_summary_label do
    condition
    cart_summary_label
    equation_tokens { [].to_json }
  end
end
