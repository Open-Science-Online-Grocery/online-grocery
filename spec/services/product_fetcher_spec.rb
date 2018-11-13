# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductFetcher do
  let(:product_1) { build(:product) }
  let(:product_2) { build(:product) }
  let(:product_3) { build(:product) }
  let(:product_4) { build(:product) }
  let(:condition) { build(:condition) }
  let(:params) do
    {
      search_type: search_type,
      search_term: 'zip',
      subcategory_id: 5,
      condition_identifier: condition.uuid,
      sort_field: 'foo',
      sort_direction: 'asc'
    }
  end
  let(:product_serializer) { instance_double('ProductSerializer') }
  let(:product_sorter) do
    instance_double('ProductSorter', sorted_products: 'the sorted products!')
  end

  subject { described_class.new(params) }

  before do
    allow(Product).to receive(:name_matches) { [product_1, product_2] }
    allow(Product).to receive(:where) { [product_3, product_4] }
    allow(ProductSerializer).to receive(:new) { product_serializer }
    allow(product_serializer).to receive(:serialize).and_return(
      'first serialized product',
      'second serialized product'
    )
    allow(ProductSorter).to receive(:new) { product_sorter }
    allow(Condition).to receive(:find_by) { condition }
  end

  context 'when search term should be used to fetch products' do
    let(:search_type) { 'term' }

    it 'calls classes with the expected args' do
      expect(Product).to receive(:name_matches).with('zip')
      expect(Condition).to receive(:find_by).with(uuid: condition.uuid)
      expect(ProductSerializer).to receive(:new).with(product_1, condition)
      expect(ProductSerializer).to receive(:new).with(product_2, condition)
      expect(ProductSorter).to receive(:new).with(
        ['first serialized product', 'second serialized product'],
        condition,
        'foo',
        'asc'
      )
      expect(subject.fetch_products).to eq 'the sorted products!'
    end
  end

  context 'when subcategory should be used to fetch products' do
    let(:search_type) { 'category' }

    it 'calls classes with the expected args' do
      expect(Product).to receive(:where).with(subcategory_id: 5)
      expect(Condition).to receive(:find_by).with(uuid: condition.uuid)
      expect(ProductSerializer).to receive(:new).with(product_3, condition)
      expect(ProductSerializer).to receive(:new).with(product_4, condition)
      expect(ProductSorter).to receive(:new).with(
        ['first serialized product', 'second serialized product'],
        condition,
        'foo',
        'asc'
      )
      expect(subject.fetch_products).to eq 'the sorted products!'
    end
  end
end
