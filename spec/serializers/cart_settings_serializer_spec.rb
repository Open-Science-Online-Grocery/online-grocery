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
  let(:condition) { build(:condition) }
  let(:cart) { instance_double('Cart') }
  let(:cart_summarizer) do
    instance_double('CartSummarizer', health_label_summary: 'a summary!')
  end

  subject { described_class.new(condition, []) }

  before do
    allow(Cart).to receive(:new) { cart }
    allow(CartSummarizer).to receive(:new) { cart_summarizer }
    allow(condition).to receive(:condition_cart_summary_labels) do
      [label_1, label_2, label_3]
    end
  end

  describe '#serialize' do
    it 'returns the expected data' do
      expect(CartSummarizer).to receive(:new).with(condition, cart)
      expected_results = {
        health_label_summary: 'a summary!',
        label_image_urls: ['first/label/url', 'third/label/url']
      }
      expect(subject.serialize).to eq expected_results
    end
  end
end
