# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutProductsExporter do
  let(:category_1) { build(:category, name: 'Chips') }
  let(:category_2) { build(:category, name: 'Nuts and Seeds') }
  let(:subcategory_1) { build(:subcategory, name: 'Corn Chips') }
  let(:subcategory_2) { build(:subcategory, name: 'Pistachios') }

  let(:product_1) do
    build(
      :product,
      name: 'Doritos',
      category: category_1,
      subcategory: subcategory_1,
      serving_size: 1,
      serving_size_grams: 1,
      calories_from_fat: 1,
      calories: 1,
      caloric_density: 1,
      total_fat: 1,
      saturated_fat: 1,
      trans_fat: 1,
      poly_fat: 1,
      mono_fat: 1,
      cholesterol: 1,
      sodium: 1,
      potassium: 1,
      carbs: 1,
      fiber: 1,
      sugar: 1,
      protein: 1,
      price: 1,
      starpoints: 1
    )
  end
  let(:product_2) do
    build(
      :product,
      name: 'Pepitas',
      category: category_2,
      subcategory: subcategory_2,
      serving_size: 2,
      serving_size_grams: 2,
      calories_from_fat: 2,
      calories: 2,
      caloric_density: 2,
      total_fat: 2,
      saturated_fat: 2,
      trans_fat: 2,
      poly_fat: 2,
      mono_fat: 2,
      cholesterol: 2,
      sodium: 2,
      potassium: 2,
      carbs: 2,
      fiber: 2,
      sugar: 2,
      protein: 2,
      price: 2,
      starpoints: 2
    )
  end
  let(:result_1) do
    instance_double(
      'ExperimentResult',
      session_identifier: 'aaaaa',
      quantity: 1,
      product: product_1
    )
  end
  let(:result_2) do
    instance_double(
      'ExperimentResult',
      session_identifier: 'bbbbb',
      quantity: 1,
      product: product_1
    )
  end
  let(:result_3) do
    instance_double(
      'ExperimentResult',
      session_identifier: 'bbbbb',
      quantity: 2,
      product: product_2
    )
  end
  let(:experiment) { instance_double('Experiment') }
  let(:expected_output) do
    <<~CSV
      Participant,Item1_Quantity,Item1_Name,Item1_Price,Item1_Category,Item1_Subcategory,Item1_Serving_size,Item1_Serving_size_grams,Item1_Calories_from_fat,Item1_Calories,Item1_Caloric_density,Item1_Total_fat,Item1_Saturated_fat,Item1_Trans_fat,Item1_Poly_fat,Item1_Mono_fat,Item1_Cholesterol,Item1_Sodium,Item1_Potassium,Item1_Carbs,Item1_Fiber,Item1_Sugar,Item1_Protein,Item1_Starpoints,Item2_Quantity,Item2_Name,Item2_Price,Item2_Category,Item2_Subcategory,Item2_Serving_size,Item2_Serving_size_grams,Item2_Calories_from_fat,Item2_Calories,Item2_Caloric_density,Item2_Total_fat,Item2_Saturated_fat,Item2_Trans_fat,Item2_Poly_fat,Item2_Mono_fat,Item2_Cholesterol,Item2_Sodium,Item2_Potassium,Item2_Carbs,Item2_Fiber,Item2_Sugar,Item2_Protein,Item2_Starpoints,TotalPrice_Pretax,TotalNumItems,Total_Serving_size_grams,Total_Calories_from_fat,Total_Calories,Total_Caloric_density,Total_Total_fat,Total_Saturated_fat,Total_Trans_fat,Total_Poly_fat,Total_Mono_fat,Total_Cholesterol,Total_Sodium,Total_Potassium,Total_Carbs,Total_Fiber,Total_Sugar,Total_Protein,Total_Starpoints
      aaaaa,1,Doritos,1.0,Chips,Corn Chips,1,1.0,1,1,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1,1,1,1,1,1,1,,,,,,,,,,,,,,,,,,,,,,,,1.0,1,1.0,1,1,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1,1,1,1,1,1,1
      bbbbb,1,Doritos,1.0,Chips,Corn Chips,1,1.0,1,1,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1,1,1,1,1,1,1,2,Pepitas,2.0,Nuts and Seeds,Pistachios,2,2.0,2,2,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2,2,2,2,2,2,2,5.0,3,5.0,5,5,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5,5,5,5,5,5,5
    CSV
  end

  subject { described_class.new(experiment) }

  before do
    allow(experiment).to receive_message_chain(:experiment_results, :includes, :where) do
      [result_1, result_2, result_3]
    end
  end

  describe '#generate_csv' do
    it 'returns the expected data' do
      expect(subject.generate_csv).to eq expected_output
    end
  end
end
