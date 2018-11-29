# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartSummarizer do
  let(:condition) do
    build(
      :condition,
      show_price_total: true,
      show_food_count: true
    )
  end
  let(:cart) do
    instance_double(
      'Cart',
      total_products: 10,
      number_of_products_with_label: 3,
      percent_of_products_with_label: 33.33333
    )
  end

  subject { described_class.new(condition, cart) }

  before do
    allow(condition).to receive(:condition_cart_summary_labels) do
      [label_1, label_2, label_3]
    end
  end

  describe '#health_label_summary' do
    context 'when no food count is shown' do
      before do
        allow(condition).to receive(:show_food_count) { false }
      end

      it 'returns nil' do
        expect(subject.health_label_summary).to be_nil
      end
    end

    context 'when ratio count should be shown' do
      before do
        allow(condition).to receive(:ratio_count?) { true }
      end

      context 'when label has a name' do
        before do
          allow(condition).to receive(:label_name) { 'foo' }
        end

        it 'returns the expected text' do
          expect(subject.health_label_summary).to eq '3 out of 10 products have the foo label'
        end
      end

      context 'when label has no name' do
        before do
          allow(condition).to receive(:label_name) { '' }
        end

        it 'returns the expected text' do
          expect(subject.health_label_summary).to eq '3 out of 10 products have a health label'
        end
      end
    end

    context 'when percent count should be shown' do
      before do
        allow(condition).to receive(:ratio_count?) { false }
        allow(condition).to receive(:label_name) { 'foo' }
      end

      it 'returns the expected text' do
        expect(subject.health_label_summary).to eq '33% of products have the foo label'
      end
    end
  end
end
