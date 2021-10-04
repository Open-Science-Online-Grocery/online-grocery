# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConditionManager do
  let(:condition) { Condition.new }
  let(:condition_label) { build :condition_label, condition: condition }
  let(:orig_params) do
    { foo: 'bar' }
  end
  let(:adjusted_params) do
    { name: 'hello' }
  end
  let(:params_adjuster) do
    instance_double(
      'ConditionParamsAdjuster',
      adjusted_params:  adjusted_params
    )
  end

  subject { described_class.new(condition, orig_params) }

  before do
    allow(condition).to receive(:save) { true }
    allow(ConditionParamsAdjuster).to receive(:new) { params_adjuster }
  end

  describe '#assign_params' do
    it 'assigns the adjusted_params' do
      expect(condition).to receive(:attributes=).with(adjusted_params)
      expect(ConditionParamsAdjuster).to receive(:new).with(orig_params)
      subject.assign_params
    end
  end

  describe '#update_condition' do
    context 'when condition is a new record' do
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

    describe 'tag file handling' do
      let!(:condition) { create(:condition) }
      let!(:current_tag_file) { condition.tag_csv_files.create }
      let(:tag_importer) { instance_double 'TagImporter', import: true }
      let(:suggestion_manager) do
        instance_double 'SuggestionsCsvManager', import: true
      end

      subject { described_class.new(condition.reload, orig_params) }

      before do
        allow(TagImporter).to receive(:new) { tag_importer }
        allow(SuggestionsCsvManager).to receive(:new) { suggestion_manager }
      end

      context 'when current tag file does not change' do
        it 'does not call the TagImporter' do
          expect(subject.update_condition).to eq true
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
        let(:adjusted_params) do
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
