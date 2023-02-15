# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConditionManager do
  let(:condition) { Condition.new(show_custom_attribute_on_product: true) }
  let(:condition_label) { build(:condition_label, condition: condition) }
  let(:orig_params) do
    { foo: 'bar' }
  end
  let(:adjusted_params) do
    { name: 'hello' }
  end
  let(:params_adjuster) do
    instance_double(
      ConditionParamsAdjuster,
      adjusted_params: adjusted_params
    )
  end
  let(:suggestion_manager) do
    instance_double CsvFileManagers::Suggestion, import: true
  end
  let(:sorting_manager) do
    instance_double CsvFileManagers::Sorting, import: true
  end
  let(:product_attribute_manager) do
    instance_double CsvFileManagers::ProductAttribute, import: true
  end
  let(:tag_importer) { instance_double TagImporter, import: true }

  subject { described_class.new(condition, orig_params) }

  before do
    allow(condition).to receive(:save) { true }
    allow(ConditionParamsAdjuster).to receive(:new) { params_adjuster }
    allow(TagImporter).to receive(:new) { tag_importer }
    allow(CsvFileManagers::Suggestion).to receive(:new) { suggestion_manager }
    allow(CsvFileManagers::Sorting).to receive(:new) { sorting_manager }
    allow(CsvFileManagers::ProductAttribute).to receive(:new) { product_attribute_manager }
  end

  describe '#assign_params' do
    it 'assigns the adjusted_params' do
      expect(condition).to receive(:attributes=).with(adjusted_params)
      expect(ConditionParamsAdjuster).to receive(:new).with(orig_params)
      subject.assign_params
    end
  end

  describe '#update_condition' do
    it 'coordinates with the expected classes' do
      expect(subject.update_condition).to be true
      expect(subject.errors).to be_empty
      expect(CsvFileManagers::Suggestion).to have_received(:new).with(condition)
      expect(CsvFileManagers::Sorting).to have_received(:new).with(condition)
      expect(CsvFileManagers::ProductAttribute).to have_received(:new).with(condition)
    end

    describe 'cart summary label attributes' do
      context 'when provided label has no id' do
        let(:adjusted_params) do
          {
            condition_cart_summary_labels_attributes: {
              '0' => {
                label_type: CartSummaryLabel.types.provided,
                cart_summary_label_id: nil
              }
            }
          }
        end

        it 'returns false and has errors' do
          expect(subject.update_condition).to be_falsy
          expect(subject.errors.join(' ')).to include 'image must be uploaded'
        end
      end

      context 'when custom image is missing' do
        let(:adjusted_params) do
          {
            condition_cart_summary_labels_attributes: {
              '0' => {
                cart_summary_label_attributes: {
                  image_cache: nil
                }
              }
            }
          }
        end

        it 'returns false and has errors' do
          expect(subject.update_condition).to be_falsy
          expect(subject.errors.join(' ')).to include 'image must be uploaded'
        end
      end

      context 'when required cart image data is present' do
        let(:adjusted_params) do
          {
            condition_cart_summary_labels_attributes: {
              '0' => {
                label_type: CartSummaryLabel.types.provided,
                cart_summary_label_id: 123
              },
              '1' => {
                cart_summary_label_attributes: {
                  image_cache: 'some image'
                }
              }
            }
          }
        end

        it 'returns true and has no errors' do
          expect(subject.update_condition).to be_truthy
          expect(subject.errors).to be_empty
        end
      end
    end

    describe 'setting excluded subcategories' do
      context 'when excluding some subcategories' do
        before do
          allow(condition).to receive(:included_subcategory_ids) { [1, 2, 3] }
          allow(Subcategory).to receive_message_chain(:where, :not).with(
            id: [1, 2, 3]
          ).and_return(
            [{ id: 4 }, { id: 5 }]
          )
        end

        it 'sets the expected excluded_subcategory_ids' do
          expect(condition).to receive(:excluded_subcategory_ids=).with([4, 5])
          subject.update_condition
        end
      end

      context 'when excluding no subcategories' do
        before do
          allow(condition).to receive(:included_subcategory_ids) { [1, 2, 3] }
          allow(Subcategory).to receive_message_chain(:where, :not).with(
            id: [1, 2, 3]
          ).and_return([])
        end

        it 'sets the expected excluded_subcategory_ids' do
          expect(condition).to receive(:excluded_subcategory_ids=).with([])
          subject.update_condition
        end
      end
    end

    describe 'tag file handling' do
      let!(:condition) { create(:condition) }
      let!(:current_tag_file) { condition.tag_csv_files.create }

      subject { described_class.new(condition.reload, orig_params) }

      context 'when current tag file does not change' do
        it 'does not call the TagImporter' do
          expect(subject.update_condition).to be true
          expect(subject.errors).to be_empty
          expect(TagImporter).not_to have_received(:new)
        end
      end

      context 'when current tag file is removed' do
        let(:adjusted_params) do
          {
            tag_csv_files_attributes: { '0' => { id: current_tag_file.id, active: '0' } }
          }
        end

        it 'calls the TagImporter' do
          expect(subject.update_condition).to be true
          expect(subject.errors).to be_empty
          expect(TagImporter).to have_received(:new).with(
            file: nil,
            condition: condition
          )
          expect(tag_importer).to have_received(:import)
        end
      end

      context 'when current tag file changes' do
        let(:new_tag_file) do
          fixture_file_upload(
            file_fixture(
              'product_data_csv_files/product_data_default_scope.csv'
            )
          )
        end
        let(:adjusted_params) do
          { new_tag_csv_file: new_tag_file }
        end

        it 'calls the TagImporter' do
          expect(subject.update_condition).to be true
          expect(subject.errors).to be_empty
          expect(TagImporter).to have_received(:new).with(
            file: new_tag_file,
            condition: condition
          )
          expect(tag_importer).to have_received(:import)
        end

        context 'when tag import fails' do
          let(:tag_importer) do
            instance_double TagImporter, import: false, errors: ['boom']
          end

          it 'returns false and has errors' do
            expect(subject.update_condition).to be false
            expect(subject.errors).to include 'boom'
          end
        end
      end
    end

    context 'when updating suggestions fails' do
      let(:suggestion_manager) do
        instance_double(
          CsvFileManagers::Suggestion,
          import: false,
          errors: ['kapow']
        )
      end

      it 'returns false and has errors' do
        expect(subject.update_condition).to be false
        expect(subject.errors).to include 'kapow'
      end
    end

    context 'when updating custom sortings fails' do
      let(:sorting_manager) do
        instance_double(
          CsvFileManagers::Sorting,
          import: false,
          errors: ['ouch']
        )
      end

      it 'returns false and has errors' do
        expect(subject.update_condition).to be false
        expect(subject.errors).to include 'ouch'
      end
    end

    context 'when updating custom product attributes fails' do
      let(:product_attribute_manager) do
        instance_double(
          CsvFileManagers::ProductAttribute,
          import: false,
          errors: ['ouch']
        )
      end

      it 'returns false and has errors' do
        expect(subject.update_condition).to be false
        expect(subject.errors).to include 'ouch'
      end
    end
  end
end
