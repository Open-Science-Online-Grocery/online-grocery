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
    it { is_expected.to have_many(:suggestion_csv_files) }
    it { is_expected.to have_many(:product_tags) }
    it { is_expected.to have_many(:tags).through(:product_tags) }
    it { is_expected.to have_many(:subtags).through(:product_tags) }
    it { is_expected.to have_many(:product_suggestions) }
    it { is_expected.to have_many(:condition_cart_summary_labels) }
    it { is_expected.to have_many(:cart_summary_labels) }
    it { is_expected.to have_many(:condition_labels) }
    it { is_expected.to have_many(:labels).through(:condition_labels) }
    it { is_expected.to have_many(:subcategory_exclusions) }
    it { is_expected.to have_many(:excluded_subcategories).through(:subcategory_exclusions) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:product_sort_fields) }
    it { is_expected.to accept_nested_attributes_for(:condition_cart_summary_labels) }
    it { is_expected.to accept_nested_attributes_for(:condition_labels) }
    it { is_expected.to accept_nested_attributes_for(:tag_csv_files) }
    it { is_expected.to accept_nested_attributes_for(:suggestion_csv_files) }
  end

  describe 'category and subcategory methods' do
    let!(:category_1) { create(:category) }
    let!(:category_2) { create(:category) }
    let!(:category_3) { create(:category) }
    let!(:subcategory_1) { create(:subcategory, category: category_1) }
    let!(:subcategory_2) { create(:subcategory, category: category_2) }
    let!(:subcategory_3) { create(:subcategory, category: category_3) }
    let!(:subcategory_4) { create(:subcategory, category: category_3) }

    before do
      allow(subject).to receive(:excluded_subcategory_ids) do
        [subcategory_2.id, subcategory_4.id]
      end
    end

    describe '#included_subcategories' do
      it 'returns the expected subcategories' do
        expect(subject.included_subcategories).to eq [subcategory_1, subcategory_3]
      end
    end

    describe '#included_category_ids' do
      it 'returns the expected category ids' do
        expect(subject.included_category_ids).to eq [category_1.id, category_3.id]
      end
    end

    describe '#included_subcategory_ids' do
      it 'returns the expected subcategory ids' do
        expect(subject.included_subcategory_ids).to eq [subcategory_1.id, subcategory_3.id]
      end
    end
  end
end
