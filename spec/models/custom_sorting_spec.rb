# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomSorting, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :sort_order }
    it { is_expected.to validate_presence_of :session_identifier }
    it do
      expect(subject).to validate_uniqueness_of(:sort_order)
        .scoped_to(:condition_id, :session_identifier)
    end
    it do
      expect(subject).to validate_uniqueness_of(:product_id)
        .scoped_to(:condition_id, :session_identifier)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:condition) }
    it { is_expected.to belong_to(:sort_file) }
    it { is_expected.to belong_to(:product) }
  end
end
