# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Equations::Cart do
  let(:token_string) do
    [
      { 'type' => 'variable', 'value' => 'avg_calories_from_fat' },
      { 'type' => 'operator', 'value' => '<' },
      { 'type' => 'digit', 'value' => '2' },
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
          { 'type' => 'variable', 'value' => 'avg_calories_from_fat' },
          { 'type' => 'operator', 'value' => '+' },
          { 'type' => 'digit', 'value' => '2' },
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
          { 'type' => 'variable', 'value' => 'avg_calories_from_fat' },
          { 'type' => 'digit', 'value' => '2' },
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
      expect(subject.to_s).to eq 'avg_calories_from_fat < 20'
    end
  end

  describe '#evaluate' do
    context 'when it evaluates to false' do
      let(:cart) { instance_double('Cart', avg_calories_from_fat: 20) }

      it 'returns false' do
        cart_data = subject.prepare_cart_data(cart)
        expect(subject.evaluate(cart_data)).to eq false
      end
    end

    context 'when it evaluates to true' do
      let(:cart) { instance_double('Cart', avg_calories_from_fat: 19) }

      it 'returns true' do
        cart_data = subject.prepare_cart_data(cart)
        expect(subject.evaluate(cart_data)).to eq true
      end
    end

    context 'when equation has no tokens' do
      let(:token_string) { [].to_json }
      let(:cart) { instance_double('Cart', avg_calories_from_fat: 19) }

      it 'returns nil' do
        cart_data = subject.prepare_cart_data(cart)
        expect(subject.evaluate(cart_data)).to be_nil
      end
    end
  end
end