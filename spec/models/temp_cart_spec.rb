# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TempCart do
  describe 'associations' do
    it { is_expected.to have_many(:cart_items).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:cart_items) }
  end
end
