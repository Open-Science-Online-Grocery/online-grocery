# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageDescriber do
  subject { described_class.new(params) }

  describe '#description' do
    context 'when the page displays search results' do
      let(:params) do
        {
          search_type: ProductFetcher.term_search_type,
          search_term: 'potatoes'
        }
      end

      it 'returns the expected string' do
        expect(subject.description).to eq 'Search results: "potatoes"'
      end
    end

    context 'when the page displays products by subsubcategory' do
      let(:subsubcategory) { build(:subsubcategory, id: 1, name: 'Foo') }
      let(:params) do
        {
          search_type: 'something else',
          selected_category_type: ProductFetcher.category_type,
          selected_subsubcategory_id: 1
        }
      end

      before do
        allow(Subsubcategory).to receive(:find).with(1).and_return(subsubcategory)
      end

      it 'returns the expected string' do
        expect(subject.description).to eq 'Subsubcategory: Foo'
      end
    end

    context 'when the page displays products by subcategory' do
      let(:subcategory) { build(:subcategory, id: 2, name: 'Bar') }
      let(:params) do
        {
          search_type: 'something else',
          selected_category_type: ProductFetcher.category_type,
          selected_subcategory_id: 2
        }
      end

      before do
        allow(Subcategory).to receive(:find).with(2).and_return(subcategory)
      end

      it 'returns the expected string' do
        expect(subject.description).to eq 'Subcategory: Bar'
      end
    end

    context 'when the page displays products by category' do
      let(:category) { build(:category, id: 3, name: 'Baz') }
      let(:params) do
        {
          search_type: 'something else',
          selected_category_type: ProductFetcher.category_type,
          selected_category_id: 3
        }
      end

      before do
        allow(Category).to receive(:find).with(3).and_return(category)
      end

      it 'returns the expected string' do
        expect(subject.description).to eq 'Category: Baz'
      end
    end

    context 'when the page displays products by subtag' do
      let(:subtag) { build(:subtag, id: 4, name: 'Qux') }
      let(:params) do
        {
          search_type: 'something else',
          selected_category_type: ProductFetcher.tag_type,
          selected_subcategory_id: 4
        }
      end

      before do
        allow(Subtag).to receive(:find).with(4).and_return(subtag)
      end

      it 'returns the expected string' do
        expect(subject.description).to eq 'Custom Subcategory: Qux'
      end
    end

    context 'when the page displays products by tag' do
      let(:tag) { build(:tag, id: 5, name: 'Zim') }
      let(:params) do
        {
          search_type: 'something else',
          selected_category_type: ProductFetcher.tag_type,
          selected_category_id: 5
        }
      end

      before do
        allow(Tag).to receive(:find).with(5).and_return(tag)
      end

      it 'returns the expected string' do
        expect(subject.description).to eq 'Custom Category: Zim'
      end
    end
  end
end
