# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagImporter do
  describe '#import' do
    let(:uploaded_file) { File.new(file_fixture(file_with_path)) }
    let(:file_with_path) { "tag_imports/#{file_name}" }
    let(:condition) { create :condition }

    subject { described_class.new(file: uploaded_file, condition: condition) }

    context 'when the file is a csv' do
      before :all do
        DatabaseCleaner.strategy = [:truncation, pre_count: true]
        DatabaseCleaner.clean
        DatabaseCleaner.strategy = :transaction

        category_1 = Category.create!(name: 'Category 1')
        subcategory_1 = Subcategory.create!(name: 'Subcategory 1')
        Product.create!(
          name: 'Product 1',
          category_id: category_1.id,
          subcategory_id: subcategory_1.id
        )

        category_2 = Category.create!(name: 'Category 2')
        subcategory_2 = Subcategory.create!(name: 'Subcategory 2')
        Product.create!(
          name: 'Product 2',
          category_id: category_2.id,
          subcategory_id: subcategory_2.id
        )
      end

      after :all do
        DatabaseCleaner.strategy = [:truncation, pre_count: true]
        DatabaseCleaner.clean
        DatabaseCleaner.strategy = :transaction
      end

      context 'when template data has been deleted' do
        let(:file_name) { 'custom_categories_missing_template_data.csv' }

        it 'returns false and adds an error' do
          expect(subject.import).to be_falsey
          expect(subject.errors).to include('Row 1: Product Name is required')
        end

        it 'does not create any data' do
          expect{ subject.import }.to change { Tag.count }.by(0)
            .and change { Subtag.count }.by(0)
            .and change { ProductTag.count }.by(0)
        end
      end

      context 'when a custom subcategory is provided without a category' do
        let(:file_name) { 'custom_categories_missing_custom_category.csv' }

        it 'returns false and adds an error' do
          expect(subject.import).to be_falsey
          expect(subject.errors).to include('Row 1: Custom Category 1 is required')
        end

        it 'does not create any data' do
          expect{ subject.import }.to change { Tag.count }.by(0)
            .and change { Subtag.count }.by(0)
            .and change { ProductTag.count }.by(0)
        end
      end

      context 'when an invalid product name is provided' do
        let(:file_name) { 'custom_categories_invalid_product_name.csv' }

        it 'returns false and adds an error' do
          expect(subject.import).to be_falsey
          expect(subject.errors).to include('Row 1: Couldn\'t find Product')
        end

        it 'does not create any data' do
          expect{ subject.import }.to change { Tag.count }.by(0)
            .and change { Subtag.count }.by(0)
            .and change { ProductTag.count }.by(0)
        end
      end

      context 'when the data is valid' do
        let(:file_name) { 'custom_categories_valid.csv' }

        it 'returns true and does not add any errors' do
          expect(subject.import).to be_truthy
          expect(subject.errors).to be_empty
        end

        it 'does creates the data from the import' do
          expect{ subject.import }.to change { Tag.count }.by(4)
            .and change { Subtag.count }.by(4)
            .and change { ProductTag.count }.by(4)
        end
      end
    end

    context 'when the file is not a csv' do
      let(:file_name) { 'custom_categories_invalid_extension.txt' }

      it 'returns false and adds an error' do
        expect(subject.import).to be_falsey
        expect(subject.errors).to include('The uploaded file must be a CSV')
      end

      it 'does not create any data' do
        expect{ subject.import }.to change { Tag.count }.by(0)
          .and change { Subtag.count }.by(0)
          .and change { ProductTag.count }.by(0)
      end
    end
  end
end
