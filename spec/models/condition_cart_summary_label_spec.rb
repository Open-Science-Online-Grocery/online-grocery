# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConditionCartSummaryLabel do
  describe 'delegations' do
    it { is_expected.to delegate_method(:built_in).to(:cart_summary_label) }
    it { is_expected.to delegate_method(:name).to(:cart_summary_label) }
    it { is_expected.to delegate_method(:image).to(:cart_summary_label) }
    it { is_expected.to delegate_method(:image?).to(:cart_summary_label) }
    it { is_expected.to delegate_method(:image_url).to(:cart_summary_label).with_prefix }
    it { is_expected.to delegate_method(:label_types).to(:class) }
    it { is_expected.to delegate_method(:variables).to(:equation).with_prefix }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:condition) }
    it { is_expected.to belong_to(:cart_summary_label) }
  end

  describe '#label_type' do
    context 'without @label_type set' do
      context 'when cart summary label is built-in' do
        before do
          allow(subject).to receive(:cart_summary_label) do
            build(:cart_summary_label, built_in: true)
          end
        end

        it 'returns provided' do
          expect(subject.label_type).to eq 'provided'
        end
      end

      context 'when cart summary label is custom' do
        before do
          allow(subject).to receive(:cart_summary_label) do
            build(:cart_summary_label, built_in: false)
          end
        end

        it 'returns custom' do
          expect(subject.label_type).to eq 'custom'
        end
      end

      context 'without a cart summary label' do
        before do
          allow(subject).to receive(:cart_summary_label) { nil }
        end

        it 'returns custom' do
          expect(subject.label_type).to eq 'custom'
        end
      end
    end

    context 'when @label_type is set' do
      before do
        subject.label_type = 'foo'
      end

      it 'returns the set value' do
        expect(subject.label_type).to eq 'foo'
      end
    end
  end

  describe '#applies_to_cart?' do
    let(:cart) { instance_double(Cart) }

    context 'when label should always be shown' do
      before do
        allow(subject).to receive(:always_show) { true }
      end

      it 'returns true' do
        expect(subject.applies_to_cart?(cart)).to be true
      end
    end

    context 'when label depends on an equation' do
      before do
        allow(subject).to receive(:always_show) { false }
        allow(subject).to receive(:equation) { equation }
      end

      context 'when equation evaluates to true' do
        let(:equation) do
          instance_double(
            Equations::Cart,
            evaluate: true,
            prepare_cart_data: {}
          )
        end

        it 'returns true' do
          expect(subject.applies_to_cart?(cart)).to be true
        end
      end

      context 'when equation evaluates to false' do
        let(:equation) do
          instance_double(
            Equations::Cart,
            evaluate: false,
            prepare_cart_data: {}
          )
        end

        it 'returns false' do
          expect(subject.applies_to_cart?(cart)).to be false
        end
      end
    end
  end
end
