# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Experiment do
  subject { build(:experiment) }

  describe 'validations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of :name }
    it do
      expect(subject).to validate_uniqueness_of(:name)
        .scoped_to(:user_id).case_insensitive
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:experiment_results) }
    it { is_expected.to have_many(:conditions) }
  end
end
