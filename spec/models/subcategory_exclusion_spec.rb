# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubcategoryExclusion do
  describe 'associations' do
    it { is_expected.to belong_to(:subcategory) }
    it { is_expected.to belong_to(:condition) }
  end
end
