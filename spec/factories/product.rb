# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    category
    subcategory
    sequence(:name) { |n| "Product #{n}" }
    size { '12 oz' }
    description { 'This is a product' }
    image_src { '' }
    serving_size { '1 cup' }
    servings { '4' }
    calories_from_fat { 0 }
    calories { 100 }
    total_fat { 0 }
    saturated_fat { 0 }
    trans_fat { 0 }
    poly_fat { 0 }
    mono_fat { 0 }
    cholesterol { nil }
    sodium { 0 }
    potassium { 0 }
    carbs { 0 }
    fiber { 0 }
    sugar { 0 }
    protein { 0 }
    vitamins { nil }
    ingredients { 'foo, bar' }
    allergens { nil }
    price { 3.05 }
    starpoints { 10 }
  end
end
