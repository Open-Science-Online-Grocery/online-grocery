# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductDataCsvManager do
  describe '.product_data_csv_attributes' do
    it 'returns a combined list of the built-in and custom category attributes' do
      expect(described_class.product_data_csv_attributes).to eql(
        'Product Id' => :product_id,
        'Product Name' => :product_name,
        'Category' => :category,
        'Subcategory' => :subcategory,
        'Custom Category 1' => :custom_category_1,
        'Custom Subcategory 1' => :custom_subcategory_1,
        'Custom Category 2' => :custom_category_2,
        'Custom Subcategory 2' => :custom_subcategory_2,
        'Custom Category 3' => :custom_category_3,
        'Custom Subcategory 3' => :custom_subcategory_3
      )
    end
  end

  describe '.built_in_category_attributes' do
    it 'returns the built-in category attributes' do
      expect(described_class.built_in_category_attributes).to eql(
        'Product Id' => :product_id,
        'Product Name' => :product_name,
        'Category' => :category,
        'Subcategory' => :subcategory
      )
    end
  end

  describe '.custom_category_attributes' do
    it 'returns the custom category attributes' do
      expect(described_class.custom_category_attributes).to eql(
        'Custom Category 1' => :custom_category_1,
        'Custom Subcategory 1' => :custom_subcategory_1,
        'Custom Category 2' => :custom_category_2,
        'Custom Subcategory 2' => :custom_subcategory_2,
        'Custom Category 3' => :custom_category_3,
        'Custom Subcategory 3' => :custom_subcategory_3
      )
    end
  end

  describe '.generate_csv' do
    let(:category_1) { create :category, name: 'Category 1' }
    let(:category_2) { create :category, name: 'Category 2' }
    let(:subcategory_1) { create :subcategory, name: 'Subcategory 1' }
    let(:subcategory_2) { create :subcategory, name: 'Subcategory 2' }
    let(:product_1) do
      create :product,
             id: 98,
             name: 'Product 1',
             category_id: category_1.id,
             subcategory_id: subcategory_1.id
    end
    let(:product_2) do
      create :product,
             id: 99,
             name: 'Product 2',
             category_id: category_2.id,
             subcategory_id: subcategory_2.id
    end

    context 'when provided with a product scope' do
      let(:expected_csv) do
        file_fixture(
          'product_data_csv_files/product_data_provided_scope.csv'
        ).read.gsub(/\r\n/, "\n") # gsub to fix newline character discrepancy
      end
      let(:product_scope) { ActiveRecord::Relation.new(Product) }

      before { allow(product_scope).to receive(:find_each).and_yield(product_1) }

      it 'returns a CSV with the expected headers and data' do
        expect(described_class.generate_csv(product_scope)).to eql expected_csv
      end
    end

    context 'with the default scope' do
      let(:expected_csv) do
        file_fixture(
          'product_data_csv_files/product_data_default_scope.csv'
        ).read.gsub(/\r\n/, "\n") # gsub to fix newline character discrepancy
      end
      let(:product_scope) { ActiveRecord::Relation.new(Product) }

      before do
        allow(Product).to receive(:all).and_return(product_scope)
        allow(product_scope).to receive(:find_each).and_yield(product_1).and_yield(product_2)
      end

      it 'returns a CSV with the expected headers and data' do
        expect(described_class.generate_csv).to eql expected_csv
      end
    end
  end
end
