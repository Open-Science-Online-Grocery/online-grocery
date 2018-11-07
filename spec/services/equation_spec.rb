# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Equation do
  let(:token_string) do
    [
      { "type" => "variable", "value" => "calories" },
      { "type" => "operator", "value" => "<" },
      { "type" => "digit", "value" => "5" },
      { "type" => "digit", "value" => "0" },
      { "type" => "digit", "value" => "0" }
    ].to_json
  end
  let(:type) { 'label' }

  subject { described_class.new(token_string, type) }

  describe 'valid?' do
    context 'when it returns a boolean as expected' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when it parses but returns the wrong type' do
      let(:token_string) do
        [
          { "type" => "variable", "value" => "calories" },
          { "type" => "operator", "value" => "+" },
          { "type" => "digit", "value" => "5" },
          { "type" => "digit", "value" => "0" },
          { "type" => "digit", "value" => "0" }
        ].to_json
      end

      it 'is invalid' do
        expect(subject).to be_invalid
      end
    end

    context 'when it does not parse' do
      let(:token_string) do
        [
          { "type" => "variable", "value" => "calories" },
          { "type" => "operator", "value" => "1" },
          { "type" => "digit", "value" => "5" },
          { "type" => "digit", "value" => "0" },
          { "type" => "digit", "value" => "0" }
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
end
