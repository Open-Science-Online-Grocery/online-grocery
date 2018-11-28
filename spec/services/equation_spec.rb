# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Equation do
  let(:token_string) { [].to_json }

  describe '.for_type' do
    it 'returns the expected subclass' do
      expect(described_class.for_type(token_string, 'label')).to be_a Equations::Label
      expect(described_class.for_type(token_string, 'sort')).to be_a Equations::Sort
      expect(described_class.for_type(token_string, 'nutrition')).to be_a Equations::Nutrition
      expect(described_class.for_type(token_string, 'cart')).to be_a Equations::Cart
    end
  end
end
