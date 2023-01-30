# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExperimentResult do
  describe 'associations' do
    it { is_expected.to belong_to(:experiment) }
    it { is_expected.to belong_to(:product) }
  end
end
