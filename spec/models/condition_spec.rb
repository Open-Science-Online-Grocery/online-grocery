# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Condition, type: :model do
  subject { build :condition }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :uuid }
    it { is_expected.to validate_presence_of :qualtrics_code }
    it { is_expected.to validate_presence_of :sort_type }
    it do
      expect(subject).to validate_uniqueness_of(:name)
        .scoped_to(:experiment_id)
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:sort_types).to(:class) }
    it { is_expected.to delegate_method(:style_use_types).to(:class) }
    it { is_expected.to delegate_method(:food_count_formats).to(:class) }
    it { is_expected.to delegate_method(:name).to(:default_sort_field).with_prefix }
    it { is_expected.to delegate_method(:variables).to(:nutrition_equation).with_prefix }
    it { is_expected.to delegate_method(:variables).to(:sort_equation).with_prefix }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:experiment) }
    it { is_expected.to belong_to(:default_sort_field).optional }
    it { is_expected.to have_many(:condition_product_sort_fields) }
    it do
      is_expected.to have_many(:product_sort_fields)
        .through(:condition_product_sort_fields)
    end
    it { is_expected.to have_many(:tag_csv_files) }
    it { is_expected.to have_many(:product_tags) }
    it { is_expected.to have_many(:tags).through(:product_tags) }
    it { is_expected.to have_many(:subtags).through(:product_tags) }
    it { is_expected.to have_many(:condition_cart_summary_labels) }
    it { is_expected.to have_many(:cart_summary_labels) }
    it { is_expected.to have_many(:condition_labels) }
    it { is_expected.to have_many(:labels).through(:condition_labels) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:product_sort_fields) }
    it { is_expected.to accept_nested_attributes_for(:condition_cart_summary_labels) }
    it { is_expected.to accept_nested_attributes_for(:condition_labels) }
    it { is_expected.to accept_nested_attributes_for(:tag_csv_files) }
  end
end
