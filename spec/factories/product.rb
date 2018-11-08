FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "product #{n}" }
    category_id do
      category = create :category
      category.id
    end
    subcategory_id do
      subcategory = create :subcategory
      subcategory.id
    end
  end
end
