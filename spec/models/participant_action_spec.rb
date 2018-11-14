# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantAction, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :session_identifier }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:condition) }
  end
end
