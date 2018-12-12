# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subcategory, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:subsubcategories) }
  end
end
