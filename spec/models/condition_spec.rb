# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Condition, type: :model do
  subject { create :condition }

  describe 'validations' do
    it { is_expected.to validate_presence_of :experiment }
    it { is_expected.to validate_presence_of :name }
    it do
      expect(subject).to validate_uniqueness_of(:name)
        .scoped_to(:experiment_id)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:experiment) }
  end
end
