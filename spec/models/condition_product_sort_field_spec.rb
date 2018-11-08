# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConditionProductSortField, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:condition) }
    it { is_expected.to belong_to(:product_sort_field) }
  end
end
