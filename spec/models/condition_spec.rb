# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Condition, type: :model do
  subject { build :condition }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :uuid }
    it do
      expect(subject).to validate_uniqueness_of(:name)
        .scoped_to(:experiment_id)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:experiment) }
    it { is_expected.to belong_to(:label) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:label) }
  end
end
