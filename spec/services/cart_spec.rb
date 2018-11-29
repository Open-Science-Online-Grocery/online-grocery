# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart do
  let(:product_1) do
    build(
      :product,
      calories_from_fat: 1,
      calories: 2,
      total_fat: 3,
      saturated_fat: 4,
      trans_fat: 5,
      poly_fat: 6,
      mono_fat: 7,
      cholesterol: 8,
      sodium: 9,
      potassium: 10,
      carbs: 11,
      fiber: 12,
      sugar: 13,
      protein: 14,
      price: 15.00,
      starpoints: 16
    )
  end
  let(:product_2) do
    build(
      :product,
      calories_from_fat: 10,
      calories: 20,
      total_fat: 30,
      saturated_fat: 40,
      trans_fat: 50,
      poly_fat: 60,
      mono_fat: 70,
      cholesterol: 80,
      sodium: 90,
      potassium: 100,
      carbs: 110,
      fiber: 120,
      sugar: 130,
      protein: 140,
      price: 150.00,
      starpoints: 160
    )
  end
  let(:product_3) do
    build(
      :product,
      calories_from_fat: 100,
      calories: 200,
      total_fat: 300,
      saturated_fat: 400,
      trans_fat: 500,
      poly_fat: 600,
      mono_fat: 700,
      cholesterol: 800,
      sodium: 900,
      potassium: 1000,
      carbs: 1100,
      fiber: 1200,
      sugar: 1300,
      protein: 1400,
      price: 1500.00,
      starpoints: 1600
    )
  end

  let(:product_data) do
    [
      { id: '1', quantity: '1', has_label: 'false' },
      { id: '2', quantity: '2', has_label: 'true' },
      { id: '3', quantity: '3', has_label: 'true' }
    ]
  end

  subject { described_class.new(product_data) }

  before do
    allow(Product).to receive(:find) do |arg|
      {
        '1' => product_1,
        '2' => product_2,
        '3' => product_3
      }[arg]
    end
  end

  describe '#total_products' do
    it 'returns the expected number' do
      expect(subject.total_products).to eq 6
    end
  end

  describe '#number_of_products_with_label' do
    it 'returns the expected number' do
      expect(subject.number_of_products_with_label).to eq 5
    end
  end

  describe '#percent_of_products_with_label' do
    it 'returns the expected number' do
      expect(subject.percent_of_products_with_label.round(3)).to eq 83.333
    end
  end

  describe '#avg_calories_from_fat' do
    it 'returns the expected number' do
      expect(subject.avg_calories_from_fat).to eq 53.5
    end
  end

  describe '#avg_calories' do
    it 'returns the expected number' do
      expect(subject.avg_calories).to eq 107
    end
  end

  describe '#avg_total_fat' do
    it 'returns the expected number' do
      expect(subject.avg_total_fat).to eq 160.5
    end
  end

  describe '#avg_saturated_fat' do
    it 'returns the expected number' do
      expect(subject.avg_saturated_fat).to eq 214
    end
  end

  describe '#avg_trans_fat' do
    it 'returns the expected number' do
      expect(subject.avg_trans_fat).to eq 267.5
    end
  end

  describe '#avg_cholesterol' do
    it 'returns the expected number' do
      expect(subject.avg_cholesterol).to eq 428
    end
  end

  describe '#avg_sodium' do
    it 'returns the expected number' do
      expect(subject.avg_sodium).to eq 481.5
    end
  end

  describe '#avg_carbs' do
    it 'returns the expected number' do
      expect(subject.avg_carbs).to eq 588.5
    end
  end

  describe '#avg_fiber' do
    it 'returns the expected number' do
      expect(subject.avg_fiber).to eq 642
    end
  end

  describe '#avg_sugar' do
    it 'returns the expected number' do
      expect(subject.avg_sugar).to eq 695.5
    end
  end

  describe '#avg_protein' do
    it 'returns the expected number' do
      expect(subject.avg_protein).to eq 749
    end
  end

  describe '#avg_price' do
    it 'returns the expected number' do
      expect(subject.avg_price).to eq 802.5
    end
  end

  describe '#avg_starpoints' do
    it 'returns the expected number' do
      expect(subject.avg_starpoints).to eq 856
    end
  end
end