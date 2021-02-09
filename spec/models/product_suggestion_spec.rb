# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSuggestion, type: :model do
  describe 'validations' do
    it do
      expect(subject).to validate_uniqueness_of(:product_id)
        .scoped_to(:condition_id)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:condition) }
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:add_on_product) }
    it { is_expected.to belong_to(:suggestion_csv_file) }
  end
end
