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
  let(:label_1) { build :label, name: 'foo label' }
  let(:label_2) { build :label, name: 'bar label' }
  let(:cart) do
    instance_double(
      'Cart',
      total_products: 10,
      number_of_products_with_each_label: {
        label_1.name => 3,
        label_2.name => 6
      },
      percent_of_products_with_each_label: {
        label_1.name => 33.33333,
        label_2.name => 66.66666
      }
    )
  end

  subject { described_class.new(condition, cart) }

  before do
    allow(condition).to receive(:labels) do
      [label_1, label_2]
    end
  end

  describe '#health_label_summaries' do
    context 'when no food count is shown' do
      before do
        allow(condition).to receive(:show_food_count) { false }
      end

      it 'returns nil' do
        expect(subject.health_label_summaries).to be_nil
      end
    end

    context 'when ratio count should be shown' do
      before do
        allow(condition).to receive(:ratio_count?) { true }
      end

      context 'when labels have names' do
        it 'returns the expected text' do
          expect(subject.health_label_summaries).to eq [
            "3 out of 10 products have the #{label_1.name} label",
            "6 out of 10 products have the #{label_2.name} label"
          ]
        end
      end

      context 'when a label is not present in any products' do
        let(:cart) do
          instance_double(
            'Cart',
            total_products: 10,
            number_of_products_with_each_label: {
              label_1.name => 3,
              label_2.name => 0
            },
            percent_of_products_with_each_label: {
              label_1.name => 33.33333,
              label_2.name => 0.0
            }
          )
        end

        it 'returns the expected text' do
          expect(subject.health_label_summaries).to eq [
            "3 out of 10 products have the #{label_1.name} label",
            "0 out of 10 products have the #{label_2.name} label"
          ]
        end
      end
    end

    context 'when percent count should be shown' do
      before do
        allow(condition).to receive(:ratio_count?) { false }
      end

      it 'returns the expected text' do
        expect(subject.health_label_summaries).to eq [
          "33% of products have the #{label_1.name} label",
          "67% of products have the #{label_2.name} label"
        ]
      end

      context 'when a label is not present in any products' do
        let(:cart) do
          instance_double(
            'Cart',
            total_products: 10,
            number_of_products_with_each_label: {
              label_1.name => 3,
              label_2.name => 0
            },
            percent_of_products_with_each_label: {
              label_1.name => 33.33333,
              label_2.name => 0.0
            }
          )
        end

        it 'returns the expected text' do
          expect(subject.health_label_summaries).to eq [
            "33% of products have the #{label_1.name} label",
            "0% of products have the #{label_2.name} label"
          ]
        end
      end
    end
  end
end
