# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutProductsExporter do
  let(:product_1) do
    build(
      :product,
      calories_from_fat: 1,
      calories: 1,
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
      calories_from_fat: 2,
      calories: 2,
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

  subject { described_class.new(experiment) }

  before do
    allow(experiment).to receive_message_chain(:experiment_results, :includes, :where) do
      [result_1, result_2, result_3]
    end
  end

  describe '#generate_csv' do
  end
end
