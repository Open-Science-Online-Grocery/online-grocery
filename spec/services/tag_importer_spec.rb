# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagImporter do
  describe '#import' do
    let(:condition) { create(:condition) }
    let(:uploaded_file) { File.new(file_fixture(file_with_path)) }
    let(:file_with_path) { "tag_imports/#{file_name}" }
    let(:condition_presenter) { ConditionPresenter.new(condition) }

    subject { described_class.new(file: uploaded_file, condition: condition_presenter) }

    context 'when the file is a csv' do
      # rubocop:disable RSpec/BeforeAfterAll
      before :all do
        DatabaseCleaner.strategy = [:truncation, pre_count: true]
        DatabaseCleaner.clean
        DatabaseCleaner.strategy = :transaction

        category_1 = Category.create!(name: 'Category 1')
        subcategory_1 = Subcategory.create!(name: 'Subcategory 1', category: category_1)
        Product.create!(
          id: 98,
          name: 'Product 1',
          category_id: category_1.id,
          subcategory_id: subcategory_1.id
        )

        category_2 = Category.create!(name: 'Category 2')
        subcategory_2 = Subcategory.create!(name: 'Subcategory 2', category: category_2)
        Product.create!(
          id: 99,
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
      # rubocop:enable RSpec/BeforeAfterAll

      context 'when template data has been deleted' do
        let(:file_name) { 'custom_categories_missing_template_data.csv' }

        it 'returns false and adds an error' do
          expect(subject.import).to be_falsey
          expect(subject.errors).to include('Row 1: Product Name is required')
        end

        it 'does not create any data' do
          expect { subject.import }.to change { Tag.count }.by(0)
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
          expect { subject.import }.to change { Tag.count }.by(0)
            .and change { Subtag.count }.by(0)
            .and change { ProductTag.count }.by(0)
        end
      end

      context 'when a custom category is provided without a subcategory' do
        let(:file_name) { 'custom_categories_missing_custom_subcategory.csv' }

        it 'returns true and does not add any errors' do
          expect(subject.import).to be_truthy
          expect(subject.errors).to be_empty
        end

        it 'does creates the data from the import' do
          expect { subject.import }.to change { Tag.count }.by(4)
            .and change { Subtag.count }.by(4)
            .and change { ProductTag.count }.by(4)
        end
      end

      context 'when an invalid product id is provided' do
        let(:file_name) { 'custom_categories_invalid_product_id.csv' }

        it 'returns false and adds an error' do
          expect(subject.import).to be_falsey
          expect(subject.errors).to include('Row 1: Couldn\'t find Product with \'id\'=99999')
        end

        it 'does not create any data' do
          expect { subject.import }.to change { Tag.count }.by(0)
            .and change { Subtag.count }.by(0)
            .and change { ProductTag.count }.by(0)
        end
      end

      context 'when there is a validation error on multiple rows' do
        let(:file_name) { 'custom_categories_multi_row_invalid_product_id.csv' }

        it 'returns false and adds an error for each incorrect row' do
          expect(subject.import).to be_falsey
          expect(subject.errors).to include('Row 1: Couldn\'t find Product with \'id\'=99999')
          expect(subject.errors).to include('Row 2: Couldn\'t find Product with \'id\'=88888')
        end

        it 'does not create any data' do
          expect { subject.import }.to change { Tag.count }.by(0)
            .and change { Subtag.count }.by(0)
            .and change { ProductTag.count }.by(0)
        end
      end

      context 'when the data is valid' do
        let(:file_name) { 'custom_categories_valid.csv' }

        it 'returns true and does not add any errors' do
          expect(condition).to receive_message_chain(:tags, :destroy_all)
          expect(subject.import).to be_truthy
          expect(subject.errors).to be_empty
        end

        it 'does creates the data from the import' do
          expect { subject.import }.to change { Tag.count }.by(4)
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
        expect { subject.import }.to change { Tag.count }.by(0)
          .and change { Subtag.count }.by(0)
          .and change { ProductTag.count }.by(0)
      end
    end

    context 'with no file' do
      let(:uploaded_file) { nil }

      it 'returns true and does not add any errors' do
        expect(condition).to receive_message_chain(:tags, :destroy_all)
        expect(subject.import).to be_truthy
        expect(subject.errors).to be_empty
      end
    end
  end
end
