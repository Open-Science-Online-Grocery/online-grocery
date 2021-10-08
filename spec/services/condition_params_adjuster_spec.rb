# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConditionParamsAdjuster do
  subject { described_class.new(params) }

  describe '#adjusted_params' do
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
        expect(subject.adjusted_params[:condition_labels_attributes]).to eq(
          '1' => {
            label_type: 'custom',
            label_attributes: { name: 'qqq' }
          }
        )
      end
    end

    context 'when replacing a field-type sort' do
      let(:params) do
        {
          sort_type: 'some other sort type',
          default_sort_field_id: 1,
          default_sort_order: 'desc'
        }
      end

      it 'removes the sort_field_id and order' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:default_sort_field_id]).to be_nil
        expect(adjusted_params[:default_sort_order]).to be_nil
      end
    end

    context 'when not replacing a field-type sort' do
      let(:params) do
        {
          sort_type: Condition.sort_types.field,
          default_sort_field_id: 1,
          default_sort_order: 'desc'
        }
      end

      it 'does not remove the sort_field_id and order' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:default_sort_field_id]).to eq 1
        expect(adjusted_params[:default_sort_order]).to eq 'desc'
      end
    end

    context 'when replacing a calculation sort' do
      let(:params) do
        {
          sort_type: 'some other sort type',
          sort_equation_tokens: 'some tokens'
        }
      end

      it 'removes the equation tokens' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:sort_equation_tokens]).to be_nil
      end
    end

    context 'when not replacing a calculation sort' do
      let(:params) do
        {
          sort_type: Condition.sort_types.calculation,
          sort_equation_tokens: 'some tokens'
        }
      end

      it 'does not remove the equation tokens' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:sort_equation_tokens]).to eq 'some tokens'
      end
    end

    context 'when replacing a calculation for styling' do
      let(:params) do
        {
          nutrition_equation_tokens: 'some tokens',
          style_use_type: 'some other type'
        }
      end

      it 'removes the equation tokens' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:nutrition_equation_tokens]).to be_nil
      end
    end

    context 'when not replacing a calculation for styling' do
      let(:params) do
        {
          nutrition_equation_tokens: 'some tokens',
          style_use_type: Condition.style_use_types.calculation
        }
      end

      it 'removes the equation tokens' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:nutrition_equation_tokens]).to eq 'some tokens'
      end
    end

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

      it 'removes attrs for the existing tag file' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:tag_csv_files_attributes]).to be_nil
      end
    end

    context 'when not replacing a tag csv file' do
      let(:params) do
        {
          tag_csv_files_attributes: { '0' => { id: '27', active: '1' } }
        }
      end

      it 'updates the existing tag file' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:tag_csv_files_attributes]).to eq(
          '0' => { id: '27', active: '1' }
        )
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
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:suggestion_csv_files_attributes]).to be_nil
      end
    end

    context 'when not replacing a suggestion csv file' do
      let(:params) do
        {
          suggestion_csv_files_attributes: { '0' => { id: '27', active: '1' } }
        }
      end

      it 'updates the existing suggestion file' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:suggestion_csv_files_attributes]).to eq(
          '0' => { id: '27', active: '1' }
        )
      end
    end

    context 'when replacing a sorting csv file' do
      let(:params) do
        {
          sort_type: 'file',
          new_sort_file: fixture_file_upload(
            file_fixture(
              'product_data_csv_files/product_data_default_scope.csv'
            )
          ),
          sort_files_attributes: { '0' => { id: '27', active: '1' } }
        }
      end

      it 'does not update the existing sorting file' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:sort_files_attributes]).to be_nil
      end
    end

    context 'when not replacing a sorting csv file' do
      let(:params) do
        {
          sort_type: 'file',
          sort_files_attributes: { '0' => { id: '27', active: '1' } }
        }
      end

      it 'updates the existing sorting file' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:sort_files_attributes]).to eq(
          '0' => { id: '27', active: '1' }
        )
      end
    end

    context 'when not using a sort_type of file' do
      let(:params) do
        {
          sort_type: 'none',
          sort_files_attributes: { '0' => { id: '27', active: '1' } }
        }
      end

      it 'deactivates the current sort file' do
        adjusted_params = subject.adjusted_params
        expect(adjusted_params[:sort_files_attributes]).to eq(
          '0' => { id: '27', active: 0 }
        )
      end
    end
  end
end
