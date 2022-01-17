# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/InstanceVariable
RSpec.describe CsvFileManagers::Sorting do
  let(:product_1) { build(:product, id: 111) }
  let(:product_2) { build(:product, id: 222) }

  describe '.generate_csv' do
    let(:product_relation) { instance_double('Product::ActiveRecord_Relation') }
    let(:condition) { instance_double('Condition', products: product_relation) }

    before do
      allow(product_relation).to receive(:find_each)
        .and_yield(product_1)
        .and_yield(product_2)
    end

    it 'generates the expected CSV' do
      expected_result = <<~CSV
        Participant Id,Product Id,Product Rank
        "",111,""
        "",222,""
      CSV
      result = described_class.generate_csv(condition)
      expect(result).to eq expected_result
    end
  end

  describe '#import' do
    let(:filepath) { Rails.root.join('spec/fixtures/files/sorting/good_1.csv') }
    let(:csv) do
      ActionDispatch::Http::UploadedFile.new(
        tempfile: File.open(filepath),
        filename: 'good_1.csv'
      )
    end
    let(:sort_file) { build(:sort_file, file: csv) }
    let(:condition) do
      build(:condition)
    end

    subject { described_class.new(condition) }

    before do
      allow(condition).to receive(:current_sort_file) { sort_file }
      allow(Product).to receive(:all) { [product_1, product_2] }
      allow(CustomSorting).to receive(:import) do |_cols, values, _opts|
        @built_records = values
        true
      end
    end

    context 'when loading a new file' do
      it 'returns true and has no errors' do
        expect(subject.import).to eq true
        expect(subject.errors).to be_empty
        expect(CustomSorting).to have_received(:import).with(
          %i[
            session_identifier
            condition_id
            sort_file_id
            product_id
            sort_order
          ],
          array_including(
            instance_of(Array),
            instance_of(Array)
          ),
          timestamps: false,
          validate: false
        )
        expect(@built_records.first.first).to eq 'abc'
        expect(@built_records.first.fourth).to eq 111
        expect(@built_records.first.fifth).to eq '2'

        expect(@built_records.last.first).to eq 'abc'
        expect(@built_records.last.fourth).to eq 222
        expect(@built_records.last.fifth).to eq '1'
      end
    end

    context 'when data is missing' do
      let(:filepath) { Rails.root.join('spec/fixtures/files/sorting/bad_1.csv') }

      it 'returns false and has errors' do
        expect(subject.import).to eq false
        expect(subject.errors).not_to be_empty
        expect(CustomSorting).not_to have_received(:import)
      end
    end

    context 'when data has duplicate sort orders' do
      let(:filepath) { Rails.root.join('spec/fixtures/files/sorting/bad_2.csv') }

      it 'returns false and has errors' do
        expect(subject.import).to eq false
        expect(subject.errors).not_to be_empty
        expect(CustomSorting).not_to have_received(:import)
      end
    end

    context 'when data has duplicate product ids' do
      let(:filepath) { Rails.root.join('spec/fixtures/files/sorting/bad_3.csv') }

      it 'returns false and has errors' do
        expect(subject.import).to eq false
        expect(subject.errors).not_to be_empty
        expect(CustomSorting).not_to have_received(:import)
      end
    end
  end
end
# rubocop:enable RSpec/InstanceVariable
