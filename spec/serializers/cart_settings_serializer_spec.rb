# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartSettingsSerializer do
  let(:label_1) do
    instance_double(
      'ConditionCartSummaryLabel',
      applies_to_cart?: true,
      cart_summary_label_image_url: 'first/label/url'
    )
  end
  let(:label_2) do
    instance_double(
      'ConditionCartSummaryLabel',
      applies_to_cart?: false,
      cart_summary_label_image_url: 'second/label/url'
    )
  end
  let(:label_3) do
    instance_double(
      'ConditionCartSummaryLabel',
      applies_to_cart?: true,
      cart_summary_label_image_url: 'third/label/url'
    )
  end

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

  subject { described_class.new(condition, []) }

  before do
    allow(Cart).to receive(:new) { cart }
    allow(condition).to receive(:condition_cart_summary_labels) do
      [label_1, label_2, label_3]
    end
  end

  describe '#serialize' do
    context 'when no food count is shown' do
      before do
        allow(condition).to receive(:show_food_count) { false }
      end

      it 'returns the expected data' do
        expected_results = {
          health_label_summary: nil,
          show_price_total: true,
          label_image_urls: ['first/label/url', 'third/label/url']
        }
        expect(subject.serialize).to eq expected_results
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

        it 'returns the expected data' do
          expected_results = {
            health_label_summary: '3 out of 10 products have the foo label',
            show_price_total: true,
            label_image_urls: ['first/label/url', 'third/label/url']
          }
          expect(subject.serialize).to eq expected_results
        end
      end

      context 'when label has no name' do
        before do
          allow(condition).to receive(:label_name) { '' }
        end

        it 'returns the expected data' do
          expected_results = {
            health_label_summary: '3 out of 10 products have a health label',
            show_price_total: true,
            label_image_urls: ['first/label/url', 'third/label/url']
          }
          expect(subject.serialize).to eq expected_results
        end
      end
    end

    context 'when percent count should be shown' do
      before do
        allow(condition).to receive(:ratio_count?) { false }
        allow(condition).to receive(:label_name) { 'foo' }
      end

      it 'returns the expected data' do
        expected_results = {
          health_label_summary: '33% of products have the foo label',
          show_price_total: true,
          label_image_urls: ['first/label/url', 'third/label/url']
        }
        expect(subject.serialize).to eq expected_results
      end
    end
  end
end
