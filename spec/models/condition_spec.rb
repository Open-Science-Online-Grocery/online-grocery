# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Condition, type: :model do
  subject { build :condition }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :uuid }
    it do
      expect(subject).to validate_uniqueness_of(:name)
        .scoped_to(:experiment_id)
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:label_types).to(:class) }
    it { is_expected.to delegate_method(:sort_types).to(:class) }
    it { is_expected.to delegate_method(:style_use_types).to(:class) }
    it { is_expected.to delegate_method(:food_count_formats).to(:class) }
    it { is_expected.to delegate_method(:image_url).to(:label).with_prefix }
    it { is_expected.to delegate_method(:name).to(:label).with_prefix }
    it { is_expected.to delegate_method(:name).to(:default_sort_field).with_prefix }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:experiment) }
    it { is_expected.to belong_to(:label) }
    it { is_expected.to have_many(:condition_product_sort_fields) }
    it do
      is_expected.to have_many(:product_sort_fields)
        .through(:condition_product_sort_fields)
    end
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:label) }
    it { is_expected.to accept_nested_attributes_for(:product_sort_fields) }
  end
end
