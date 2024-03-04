# frozen_string_literal: true

# spec/models/api_token_request_spec.rb

require 'rails_helper'

RSpec.describe ApiTokenRequest do
  describe 'associations' do
    it { is_expected.to have_one(:api_token).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'scopes' do
    it 'has a pending scope' do
      expect(described_class.pending.to_sql).to eq(described_class.where(status: 0).to_sql)
    end

    it 'has an approved scope' do
      expect(described_class.approved.to_sql).to eq(described_class.where(status: 1).to_sql)
    end

    it 'has a rejected scope' do
      expect(described_class.rejected.to_sql).to eq(described_class.where(status: 2).to_sql)
    end
  end
end
