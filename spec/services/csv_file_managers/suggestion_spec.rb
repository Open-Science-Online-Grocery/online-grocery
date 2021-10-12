# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvFileManagers::Suggestion do
  let(:product_1) { build(:product) }
  let(:product_2) { build(:product) }
  let(:add_on_1) { build(:product) }
  let(:add_on_2) { build(:product) }
  let(:condition) do
    instance_double 'Condition'
  end
  let(:product_suggestion) { instance_double 'ProductSuggestion', save: true }
  let(:existing_suggestions_relation) do
    instance_double(
      'ProductSuggestion::ActiveRecord_Associations_CollectionProxy',
      build: product_suggestion,
      exists?: false,
      destroy_all: true
    )
  end
  let(:csv) do
    ActionDispatch::Http::UploadedFile.new(
      tempfile: File.open(
        Rails.root.join('spec/fixtures/files/suggestions/good_1.csv')
      ),
      filename: 'good_1.csv'
    )
  end
  let(:suggestion_file) do
    build(:suggestion_csv_file, file: csv)
  end

  subject { described_class.new(condition) }

  before do
    allow(condition).to receive(:current_suggestion_csv_file) { suggestion_file }
    allow(condition).to receive(:product_suggestions) do
      existing_suggestions_relation
    end
    allow(existing_suggestions_relation).to receive_message_chain(:where, :not) do
      existing_suggestions_relation
    end
    allow(condition).to receive_message_chain(:product_suggestions, :where, :not) do
      existing_suggestions_relation
    end
    allow(Product).to receive(:find_by) do |arg|
      {
        '1' => product_1,
        '2' => product_2,
        '11' => add_on_1,
        '22' => add_on_2
      }[arg[:id]]
    end
  end

  describe '#import' do
    context 'when loading a new file' do
      it 'returns true and has no errors' do
        expect(subject.import).to eq true
        expect(subject.errors).to be_empty
        expect(existing_suggestions_relation).to have_received(:destroy_all)
        expect(product_suggestion).to have_received(:save).twice
      end

      context 'when a product cannot be found' do
        before do
          allow(Product).to receive(:find_by) do |arg|
            {
              '1' => nil,
              '2' => product_2,
              '11' => add_on_1,
              '22' => add_on_2
            }[arg[:id]]
          end
        end

        it 'returns false and has errors' do
          expect(subject.import).to eq false
          expect(subject.errors.first).to include "Can't find product"
        end
      end

      context 'when a ProductSuggestion fails to save' do
        let(:product_suggestion) do
          instance_double 'ProductSuggestion', save: false
        end

        before do
          allow(product_suggestion).to receive_message_chain(:errors, :full_messages) do
            ['problem']
          end
        end

        it 'returns false and has errors' do
          expect(subject.import).to eq false
          expect(subject.errors).to include 'problem'
        end
      end
    end

    context 'when file has been loaded previously' do
      let(:existing_suggestions_relation) do
        instance_double(
          'ProductSuggestion::ActiveRecord_Associations_CollectionProxy',
          build: product_suggestion,
          exists?: true,
          destroy_all: true
        )
      end

      it 'does not build new product_suggestions' do
        expect(subject.import).to eq true
        expect(subject.errors).to be_empty
        expect(existing_suggestions_relation).to have_received(:destroy_all)
        expect(product_suggestion).not_to have_received(:save)
      end
    end

    context 'when current_suggestion_csv_file is nil' do
      before do
        allow(condition).to receive(:current_suggestion_csv_file) { nil }
      end

      it 'does not build new product_suggestions' do
        expect(subject.import).to eq true
        expect(subject.errors).to be_empty
        expect(existing_suggestions_relation).to have_received(:destroy_all)
        expect(product_suggestion).not_to have_received(:save)
      end
    end
  end
end
