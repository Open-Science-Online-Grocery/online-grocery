# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/LetSetup
RSpec.describe ConditionSerializer do
  let(:sort_field_1) { build(:product_sort_field, description: 'first sort field') }
  let(:sort_field_2) { build(:product_sort_field, description: 'second sort field') }
  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  let!(:category_3) { create(:category) }
  let!(:subcategory_1) { create(:subcategory, category: category_1) }
  let!(:subcategory_2) { create(:subcategory, category: category_2) }
  let!(:subcategory_3) { create(:subcategory, category: category_3) }
  let!(:subsubcategory_1) { create(:subsubcategory, subcategory: subcategory_1) }
  let!(:subsubcategory_2) { create(:subsubcategory, subcategory: subcategory_2) }
  let!(:subsubcategory_3) { create(:subsubcategory, subcategory: subcategory_2) }
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
      qualtrics_code: 'FOOBAR',
      show_products_by_subcategory: true,
      allow_searching: false
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
    allow(condition).to receive(:included_subcategories) do
      Subcategory.where(id: [subcategory_1.id, subcategory_2.id])
    end
  end

  describe '#serialize' do
    it 'returns the expected data' do
      expected_data = {
        sort_fields: ['first sort field', 'second sort field'],
        show_products_by_subcategory: true,
        categories: [category_1, category_2],
        subcategories: [subcategory_1, subcategory_2],
        subsubcategories: [subsubcategory_1, subsubcategory_2, subsubcategory_3],
        tags: [tag_1, tag_2],
        subtags: [subtag_1, subtag_2],
        filter_by_tags: true,
        only_add_to_cart_from_detail_page: true,
        show_price_total: true,
        minimum_spend: BigDecimal('10'),
        maximum_spend: BigDecimal('50'),
        may_add_to_cart_by_dollar_amount: false,
        show_guiding_stars: true,
        qualtrics_code: 'FOOBAR',
        allow_searching: false
      }
      expect(subject.serialize).to eq expected_data
    end

    context 'when not showing products by subcategory' do
      before do
        allow(condition).to receive(:show_products_by_subcategory) { false }
      end

      it 'returns the expected data' do
        expected_data = {
          sort_fields: ['first sort field', 'second sort field'],
          show_products_by_subcategory: false,
          categories: [category_1, category_2],
          subcategories: [],
          subsubcategories: [],
          tags: [tag_1, tag_2],
          subtags: [],
          filter_by_tags: true,
          only_add_to_cart_from_detail_page: true,
          show_price_total: true,
          minimum_spend: BigDecimal('10'),
          maximum_spend: BigDecimal('50'),
          may_add_to_cart_by_dollar_amount: false,
          show_guiding_stars: true,
          qualtrics_code: 'FOOBAR',
          allow_searching: false
        }
        expect(subject.serialize).to eq expected_data
      end
    end
  end
end
# rubocop:enable RSpec/LetSetup
