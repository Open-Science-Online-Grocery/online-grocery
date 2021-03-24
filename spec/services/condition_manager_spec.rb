# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConditionManager do
  let(:condition) { Condition.new }
  let(:condition_label) { build :condition_label, condition: condition }

  subject { described_class.new(condition, params) }

  before do
    allow(condition).to receive(:save) { true }
  end

  context 'when condition is a new record' do
    let(:params) do
      { name: 'foo' }
    end

    it 'sets the uuid' do
      expect(condition.uuid).to be_nil
      expect(condition).to receive(:save)
      expect(subject.update_condition).to eq true
      expect(subject.errors).to be_empty
      expect(condition.uuid).not_to be_nil
    end

    context 'when saving fails' do
      before do
        allow(condition).to receive(:save) { false }
        allow(condition).to receive_message_chain(:errors, :full_messages) do
          ['an error!']
        end
      end

      it 'returns false and has errors' do
        expect(subject.update_condition).to eq false
        expect(subject.errors).to include 'an error!'
      end
    end
  end

  context 'when replacing a built-in label' do
    let(:params) do
      {
        condition_labels_attributes: {
          '1' => {
            label_id: 1,
            label_type: 'custom',
            label_attributes: { name: 'qqq' }
          }
        }
      }
    end

    it 'removes the label_id' do
      subject.update_condition
      expect(condition.condition_labels.first.label_id).to be_nil
    end
  end

  context 'when replacing a field-type sort' do
    let(:params) do
      {
        default_sort_field_id: 1,
        default_sort_order: 'desc'
      }
    end

    it 'removes the label_id and order' do
      subject.update_condition
      expect(condition.default_sort_field_id).to be_nil
      expect(condition.default_sort_order).to be_nil
    end
  end

  context 'when replacing a calculation sort' do
    let(:params) do
      { sort_equation_tokens: 'some tokens' }
    end

    it 'removes the equation tokens' do
      subject.update_condition
      expect(condition.sort_equation_tokens).to be_nil
    end
  end

  context 'when replacing a calculation for styling' do
    let(:params) do
      {
        nutrition_equation_tokens: 'some tokens',
        style_use_type: 'always'
      }
    end

    it 'removes the equation tokens' do
      subject.update_condition
      expect(condition.nutrition_equation_tokens).to be_nil
    end
  end

  describe '#assign_params' do
    context 'when replacing a tag csv file' do
      let(:params) do
        {
          new_tag_csv_file: fixture_file_upload(
            file_fixture(
              'product_data_csv_files/product_data_default_scope.csv'
            )
          ),
          tag_csv_files_attributes: { '0' => { id: '27', active: '1' } }
        }
      end

      it 'does not update the existing tag file' do
        expect(condition).to receive(:new_tag_csv_file=)
        expect(condition).not_to receive(:tag_csv_files_attributes=)
        subject.assign_params
      end
    end

    context 'when not replacing a tag csv file' do
      let(:params) do
        {
          tag_csv_files_attributes: { '0' => { id: '27', active: '1' } }
        }
      end

      it 'updates the existing tag file' do
        expect(condition).to receive(:tag_csv_files_attributes=)
        subject.assign_params
      end
    end

    context 'when replacing a suggestion csv file' do
      let(:params) do
        {
          new_suggestion_csv_file: fixture_file_upload(
            file_fixture(
              'product_data_csv_files/product_data_default_scope.csv'
            )
          ),
          suggestion_csv_files_attributes: { '0' => { id: '27', active: '1' } }
        }
      end

      it 'does not update the existing suggestion file' do
        expect(condition).to receive(:new_suggestion_csv_file=)
        expect(condition).not_to receive(:suggestion_csv_files_attributes=)
        subject.assign_params
      end
    end

    context 'when not replacing a suggestion csv file' do
      let(:params) do
        {
          suggestion_csv_files_attributes: { '0' => { id: '27', active: '1' } }
        }
      end

      it 'updates the existing suggestion file' do
        expect(condition).to receive(:suggestion_csv_files_attributes=)
        subject.assign_params
      end
    end
  end

  describe '#update_condition' do
    describe 'tag file handling' do
      let!(:condition) { create(:condition) }
      let!(:current_tag_file) { condition.tag_csv_files.create }
      let(:tag_importer) { instance_double 'TagImporter', import: true }
      let(:suggestion_manager) do
        instance_double 'SuggestionsCsvManager', import: true
      end

      subject { described_class.new(condition.reload, params) }

      before do
        allow(TagImporter).to receive(:new) { tag_importer }
        allow(SuggestionsCsvManager).to receive(:new) { suggestion_manager }
      end

      context 'when current tag file does not change' do
        let(:params) { {} }

        it 'does not call the TagImporter' do
          expect(subject.update_condition).to eq true
          expect(subject.errors).to be_empty
          expect(TagImporter).not_to have_received(:new)
        end
      end

      context 'when current tag file is removed' do
        let(:params) do
          {
            tag_csv_files_attributes: { '0' => { id: current_tag_file.id, active: '0' } }
          }
        end

        it 'calls the TagImporter' do
          expect(subject.update_condition).to eq true
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
        let(:params) do
          { new_tag_csv_file: new_tag_file }
        end

        it 'calls the TagImporter' do
          expect(subject.update_condition).to eq true
          expect(subject.errors).to be_empty
          expect(TagImporter).to have_received(:new).with(
            file: new_tag_file,
            condition: condition
          )
          expect(tag_importer).to have_received(:import)
        end

        context 'when tag import fails' do
          let(:tag_importer) do
            instance_double 'TagImporter', import: false, errors: ['boom']
          end

          it 'returns false and has errors' do
            expect(subject.update_condition).to eq false
            expect(subject.errors).to include 'boom'
          end
        end
      end

      context 'when updating suggestions fails' do
        let(:params) { {} }
        let(:suggestion_manager) do
          instance_double(
            'SuggestionsCsvManager',
            import: false,
            errors: ['kapow']
          )
        end

        it 'returns false and has errors' do
          expect(subject.update_condition).to eq false
          expect(subject.errors).to include 'kapow'
        end
      end
    end
  end
end
