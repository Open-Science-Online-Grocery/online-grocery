# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    category
    subcategory
    sequence(:name) { |n| "Product #{n}" }
    size { '12 oz' }
    description { 'This is a product' }
    imageSrc { '' }
    servingSize { '1 cup' }
    servings { '4' }
    caloriesFromFat { 0 }
    calories { 100 }
    totalFat { 0 }
    saturatedFat { 0 }
    transFat { 0 }
    polyFat { 0 }
    monoFat { 0 }
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
