# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:subcategory) }
    it { is_expected.to belong_to(:subsubcategory).optional }
    it { is_expected.to have_many(:product_tags) }
    it { is_expected.to have_many(:product_suggestions) }
    it { is_expected.to have_many(:custom_sortings) }
    it { is_expected.to have_many(:custom_product_attributes) }
  end

  describe '.nutrition_fields' do
    it 'returns the expected fields' do
      expected_results = %i[
        serving_size_grams
        calories_from_fat
        calories
        caloric_density
        total_fat
        saturated_fat
        trans_fat
        poly_fat
        mono_fat
        cholesterol
        sodium
        potassium
        carbs
        fiber
        sugar
        protein
        starpoints
      ]
      expect(described_class.nutrition_fields).to eq expected_results
    end
  end
end
