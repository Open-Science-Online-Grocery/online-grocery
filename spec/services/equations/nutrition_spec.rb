# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Equations::Nutrition do
  let(:token_string) do
    [
      { 'type' => 'variable', 'value' => 'calories' },
      { 'type' => 'operator', 'value' => '<' },
      { 'type' => 'digit', 'value' => '5' },
      { 'type' => 'digit', 'value' => '0' },
      { 'type' => 'digit', 'value' => '0' }
    ].to_json
  end

  subject { described_class.new(token_string) }

  describe 'valid?' do
    context 'when it returns the expected type' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when it parses but returns the wrong type' do
      let(:token_string) do
        [
          { 'type' => 'variable', 'value' => 'calories' },
          { 'type' => 'operator', 'value' => '+' },
          { 'type' => 'digit', 'value' => '5' },
          { 'type' => 'digit', 'value' => '0' },
          { 'type' => 'digit', 'value' => '0' }
        ].to_json
      end

      it 'is invalid' do
        expect(subject).to be_invalid
      end
    end

    context 'when it does not parse' do
      let(:token_string) do
        [
          { 'type' => 'variable', 'value' => 'calories' },
          { 'type' => 'operator', 'value' => '1' },
          { 'type' => 'digit', 'value' => '5' },
          { 'type' => 'digit', 'value' => '0' },
          { 'type' => 'digit', 'value' => '0' }
        ].to_json
      end

      it 'is invalid' do
        expect(subject).to be_invalid
      end
    end
  end

  describe '#to_s' do
    it 'returns the expected string' do
      expect(subject.to_s).to eq 'calories < 500'
    end
  end

  describe '#evaluate' do
    context 'when it evaluates to false' do
      let(:product) { build(:product, calories: 500) }

      it 'returns false' do
        expect(subject.evaluate(product.attributes)).to eq false
      end
    end

    context 'when it evaluates to true' do
      let(:product) { build(:product, calories: 499) }

      it 'returns true' do
        expect(subject.evaluate(product.attributes)).to eq true
      end
    end

    context 'when equation has no tokens' do
      let(:token_string) { [].to_json }
      let(:product) { build(:product, calories: 499) }

      it 'returns nil' do
        expect(subject.evaluate(product.attributes)).to be_nil
      end
    end
  end
end
