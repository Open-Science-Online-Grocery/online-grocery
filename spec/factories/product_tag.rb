# frozen_string_literal: true

FactoryBot.define do
  factory :product_tag do
    tag
    subtag
    product
    condition
  end
end
