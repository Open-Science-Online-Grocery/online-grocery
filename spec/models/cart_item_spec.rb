# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem do
  describe 'associations' do
    it { is_expected.to belong_to(:temp_cart) }
    it { is_expected.to belong_to(:product) }
  end
end
