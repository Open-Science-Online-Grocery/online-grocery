# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:subcategory) }
    it { is_expected.to belong_to(:subsubcategory) }
    it { is_expected.to have_many(:product_tags) }
  end
end
