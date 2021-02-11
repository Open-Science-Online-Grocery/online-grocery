# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConditionSerializer do
  let(:sort_field_1) { build(:product_sort_field, description: 'first sort field') }
  let(:sort_field_2) { build(:product_sort_field, description: 'second sort field') }
  let(:category_1) { build(:category) }
  let(:category_2) { build(:category) }
  let(:subcategory_1) { build(:subcategory) }
  let(:subcategory_2) { build(:subcategory) }
  let(:subsubcategory_1) { build(:subsubcategory) }
  let(:subsubcategory_2) { build(:subsubcategory) }
  let(:tag_1) { build(:tag) }
  let(:tag_2) { build(:tag) }
  let(:subtag_1) { build(:subtag) }
  let(:subtag_2) { build(:subtag) }
  let(:condition) do
    build(
      :condition,
      filter_by_custom_categories: true,
      only_add_from_detail_page: true,
      minimum_spend: 10,
      maximum_spend: 50,
      may_add_to_cart_by_dollar_amount: false,
      qualtrics_code: 'FOOBAR'
    )
  end

  subject { described_class.new(condition) }

  before do
    allow(condition).to receive(:product_sort_fields) do
      [sort_field_1, sort_field_2]
    end
    allow(condition).to receive_message_chain(:tags, :order) do
      [tag_1, tag_2]
    end
    allow(condition).to receive_message_chain(:subtags, :order) do
      [subtag_1, subtag_2]
    end
    allow(Category).to receive(:order) { [category_1, category_2] }
    allow(Subcategory).to receive(:order) { [subcategory_1, subcategory_2] }
    allow(Subsubcategory).to receive(:order) { [subsubcategory_1, subsubcategory_2] }
  end

  describe '#serialize' do
    it 'returns the expected data' do
      expected_data = {
        sort_fields: ['first sort field', 'second sort field'],
        categories: [category_1, category_2],
        subcategories: [subcategory_1, subcategory_2],
        subsubcategories: [subsubcategory_1, subsubcategory_2],
        tags: [tag_1, tag_2],
        subtags: [subtag_1, subtag_2],
        filter_by_tags: true,
        only_add_to_cart_from_detail_page: true,
        show_price_total: true,
        minimum_spend: BigDecimal('10'),
        maximum_spend: BigDecimal('50'),
        may_add_to_cart_by_dollar_amount: false,
        show_guiding_stars: true,
        qualtrics_code: 'FOOBAR'
      }
      expect(subject.serialize).to eq expected_data
    end
  end
end
