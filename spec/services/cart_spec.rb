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
      { id: '1', quantity: '1', has_labels: ['bar image'] },
      { id: '2', quantity: '2', has_labels: ['foo image', 'bar image'] },
      { id: '3', quantity: '3', has_labels: ['bar image'] }
    ]
  end
  let(:condition) { create :condition }
  let(:label_1) { create :label, name: 'foo image' }
  let(:label_2) { create :label, name: 'bar image' }
  let(:cond_label_1) { create :condition_label, condition: condition, label: label_1 }
  let(:cond_label_2) { create :condition_label, condition: condition, label: label_2 }

  subject { described_class.new(product_data, condition) }

  before do
    allow(Product).to receive(:find) do |arg|
      {
        '1' => product_1,
        '2' => product_2,
        '3' => product_3
      }[arg]
    end
    cond_label_1
    cond_label_2
  end

  describe '#get_value' do
    it 'returns the expected numbers' do
      expect(subject.get_value('total_products')).to eq 6
      expect(subject.get_value('number_of_products_with_each_label')).to eql(
        'foo image' => 2,
        'bar image' => 6
      )
      expect(
        subject.get_value('percent_of_products_with_each_label')
          .transform_values { |val| val.round(3) }
      ).to eql(
        'foo image' => 33.333,
        'bar image' => 100.0
      )
      expect(subject.get_value('avg_calories_from_fat')).to eq 53.5
      expect(subject.get_value('avg_calories')).to eq 107
      expect(subject.get_value('avg_total_fat')).to eq 160.5
      expect(subject.get_value('avg_saturated_fat')).to eq 214
      expect(subject.get_value('avg_trans_fat')).to eq 267.5
      expect(subject.get_value('avg_cholesterol')).to eq 428
      expect(subject.get_value('avg_sodium')).to eq 481.5
      expect(subject.get_value('avg_carbs')).to eq 588.5
      expect(subject.get_value('avg_fiber')).to eq 642
      expect(subject.get_value('avg_sugar')).to eq 695.5
      expect(subject.get_value('avg_protein')).to eq 749
      expect(subject.get_value('avg_price')).to eq 802.5
      expect(subject.get_value('avg_starpoints')).to eq 856
      expect(subject.get_value('total_calories_from_fat')).to eq 321
      expect(subject.get_value('total_calories')).to eq 642
      expect(subject.get_value('total_total_fat')).to eq 963
      expect(subject.get_value('total_saturated_fat')).to eq 1284
      expect(subject.get_value('total_trans_fat')).to eq 1605
      expect(subject.get_value('total_cholesterol')).to eq 2568
      expect(subject.get_value('total_sodium')).to eq 2889
      expect(subject.get_value('total_carbs')).to eq 3531
      expect(subject.get_value('total_fiber')).to eq 3852
      expect(subject.get_value('total_sugar')).to eq 4173
      expect(subject.get_value('total_protein')).to eq 4494
      expect(subject.get_value('total_price')).to eq 4815
      expect(subject.get_value('total_starpoints')).to eq 5136
    end
  end
end
