# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Experiment, type: :model do
  subject { build :experiment }

  describe 'validations' do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :name }
    it do
      expect(subject).to validate_uniqueness_of(:name)
        .scoped_to(:user_id)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
