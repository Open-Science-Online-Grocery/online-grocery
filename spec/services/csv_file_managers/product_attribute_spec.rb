# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvFileManagers::ProductAttribute do
  let(:csv) do
    ActionDispatch::Http::UploadedFile.new(
      tempfile: File.open(
        Rails.root.join('spec/fixtures/files/product_attribute/good.csv')
      ),
      filename: 'good.csv'
    )
  end
  let(:product_attribute_file) { build(:product_attribute_csv_file, file: csv) }
  let(:condition) do
    instance_double(
      Condition,
      current_product_attribute_csv_file: product_attribute_file,
      custom_product_attributes: existing_attribute_relation
    )
  end
  let(:custom_product_attribute) { instance_double 'CustomProductAttribute', save: true }
  let(:existing_attribute_relation) do
    instance_double(
      'CustomProductAttribute::ActiveRecord_Associations_CollectionProxy',
      new: custom_product_attribute,
      exists?: false,
      delete_all: true
    )
  end

  let(:product) { build(:product) }

  subject { described_class.new(condition) }

  before do
    allow(existing_attribute_relation).to receive_message_chain(:where, :not) do
      existing_attribute_relation
    end
    allow(Product).to receive(:find_by) do |arg|
      {
        '1' => product,
        '2' => product
      }[arg[:id]]
    end
  end

  describe '#import' do
    context 'when loading a new file' do
      it 'returns true and has no errors' do
        expect(subject.import).to eq true
        expect(subject.errors).to be_empty
        expect(existing_attribute_relation).to have_received(:delete_all)
        expect(custom_product_attribute).to have_received(:save).twice
      end

      context 'when a product cannot be found' do
        before do
          allow(Product).to receive(:find_by) do |arg|
            {
              '1' => nil,
              '2' => product
            }[arg[:id]]
          end
        end

        it 'returns false and has errors' do
          expect(subject.import).to eq false
          expect(subject.errors.first).to include "Can't find product"
        end
      end

      context 'when a CustomProductAttribute fails to save' do
        let(:custom_product_attribute) do
          instance_double 'CustomProductAttribute', save: false
        end

        before do
          allow(custom_product_attribute).to receive_message_chain(:errors, :full_messages) do
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
      let(:existing_attribute_relation) do
        instance_double(
          'CustomProductAttribute::ActiveRecord_Associations_CollectionProxy',
          new: custom_product_attribute,
          exists?: true,
          delete_all: true
        )
      end

      it 'does not build new custom_product_attribute' do
        expect(subject.import).to eq true
        expect(subject.errors).to be_empty
        expect(existing_attribute_relation).to have_received(:delete_all)
        expect(custom_product_attribute).not_to have_received(:save)
      end
    end

    context 'when custom_product_attribute is nil' do
      before do
        allow(condition).to receive(:current_product_attribute_csv_file) { nil }
      end

      it 'does not build new custom_product_attribute' do
        expect(subject.import).to eq true
        expect(subject.errors).to be_empty
        expect(existing_attribute_relation).to have_received(:delete_all)
        expect(custom_product_attribute).not_to have_received(:save)
      end
    end
  end
end
