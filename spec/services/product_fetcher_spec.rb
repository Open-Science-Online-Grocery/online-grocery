# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductFetcher do
  let(:product_1) { build(:product) }
  let(:product_2) { build(:product) }
  let(:product_3) { build(:product) }
  let(:product_4) { build(:product) }
  let(:condition) { build(:condition) }
  let(:category_type) { nil }
  let(:filter_id) { nil }
  let(:params) do
    {
      search_type: search_type,
      search_term: 'zip',
      selected_category_id: 4,
      selected_subcategory_id: 5,
      selected_category_type: category_type,
      selected_filter_id: filter_id,
      sort_field: 'foo',
      sort_direction: 'asc'
    }
  end
  let(:product_serializer) { instance_double('ProductSerializer') }
  let(:product_sorter) do
    instance_double('ProductSorter', sorted_products: 'the sorted products!')
  end
  let(:product_relation) { instance_double 'Product::ActiveRecord_Relation' }

  subject { described_class.new(condition, params) }

  before do
    allow(Product).to receive(:includes) { product_relation }
    allow(product_relation).to receive(:name_matches) { [product_1, product_2] }
    allow(product_relation).to receive(:where) { [product_3, product_4] }
    allow(product_relation).to receive_message_chain(:joins, :where) { [product_3, product_4] }
    allow(ProductSerializer).to receive(:new) { product_serializer }
    allow(product_serializer).to receive(:serialize).and_return(
      'first serialized product',
      'second serialized product'
    )
    allow(ProductSorter).to receive(:new) { product_sorter }
  end

  context 'when search term should be used to fetch products' do
    let(:search_type) { 'term' }

    it 'calls classes with the expected args' do
      expect(product_relation).to receive(:name_matches).with('zip')
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

  context 'when category data should be used to fetch products' do
    let(:search_type) { 'category' }

    context 'when the category type is `category`' do
      let(:category_type) { 'category' }

      it 'calls classes with the expected args' do
        expect(product_relation).to receive(:where).with(subcategory_id: 5)
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

      context 'when there is also a subsubcategory' do
        let(:other_product_relation) do
          instance_double 'Product::ActiveRecord_Relation'
        end

        before do
          allow(product_relation).to receive(:where) { other_product_relation }
          allow(other_product_relation).to receive(:where) { [product_3, product_4] }
          params[:selected_subsubcategory_id] = 99
        end

        it 'calls classes with the expected args' do
          expect(product_relation).to receive(:where).with(subcategory_id: 5)
          expect(other_product_relation).to receive(:where).with(subsubcategory_id: 99)
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

    context 'when the category type is `tag`' do
      let(:category_type) { 'tag' }

      it 'calls classes with the expected args' do
        expect(product_relation.joins(:product_tags)).to receive(:where).with(
          product_tags: { subtag_id: 5 }
        )
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
end
