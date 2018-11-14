# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSortField, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_uniqueness_of :description }
  end
end
