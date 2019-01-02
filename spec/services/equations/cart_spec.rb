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
    let(:cart) { instance_double(Cart) }

    before do
      allow(cart).to receive(:get_value) do |arg|
        avg_calories_from_fat if arg == 'avg_calories_from_fat'
      end
    end

    context 'when it evaluates to false' do
      let(:avg_calories_from_fat) { 20 }

      it 'returns false' do
        expect(subject.evaluate(cart)).to eq false
      end
    end

    context 'when it evaluates to true' do
      let(:avg_calories_from_fat) { 19 }

      it 'returns true' do
        expect(subject.evaluate(cart)).to eq true
      end
    end

    context 'when equation has no tokens' do
      let(:token_string) { [].to_json }
      let(:avg_calories_from_fat) { 19 }

      it 'returns nil' do
        expect(subject.evaluate(cart)).to be_nil
      end
    end
  end
end
