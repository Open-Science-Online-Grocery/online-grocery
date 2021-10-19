# frozen_string_literal: true

require 'rails_helper'

# due to the amount of query logic in this class, this spec functions more like
# an integration test (doing actual db lookups) rather than a unit test.
# rubocop:disable RSpec/LetSetup
RSpec.describe ProductSorter do
  let!(:product_1) do
    create(:product, total_fat: 11, carbs: 5)
  end
  let!(:product_2) do
    create(:product, total_fat: 2, carbs: 9)
  end
  let!(:product_3) do
    create(:product, total_fat: 33, carbs: 6)
  end
  let(:condition) { build(:condition, sort_type: sort_type) }
  let(:product_sort_field) { build(:product_sort_field, name: 'carbs') }
  let(:product_relation) { Product.all }

  subject do
    described_class.new(
      product_relation: product_relation,
      condition: condition,
      session_identifier: 'abc',
      manual_sort_field_description: manual_sort_field_description,
      manual_sort_order: manual_sort_order
    )
  end

  before do
    allow(ProductSerializer).to receive(:new) do |product|
      OpenStruct.new(
        serialize: product.attributes
      )
    end
    allow(ProductSortField).to receive(:find_by) { product_sort_field }
  end

  describe '#sorted_products' do
    context 'when the specified manual sorting should be used' do
      let(:sort_type) { Condition.sort_types.none }
      let(:manual_sort_field_description) { 'Carbohydrates' }
      let(:manual_sort_order) { 'asc' }

      context 'when sorting by database column' do
        context 'when sorting in ascending order' do
          it 'returns the expected results' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_1.id, 1],
              [product_3.id, 2],
              [product_2.id, 3]
            ]
          end
        end

        context 'when sorting in descending order' do
          let(:manual_sort_order) { 'desc' }

          it 'returns the expected results' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_2.id, 1],
              [product_3.id, 2],
              [product_1.id, 3]
            ]
          end
        end

        context 'when some products have nil values' do
          let!(:product_3) do
            create(:product, total_fat: 33, carbs: nil)
          end

          it 'returns the products with nil values first' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_3.id, 1],
              [product_1.id, 2],
              [product_2.id, 3]
            ]
          end
        end
      end

      context 'when sorting by a field defined by serializer' do
        let(:manual_sort_field_description) { 'Custom label' }
        let(:product_sort_field) { build(:product_sort_field, name: 'label_sort') }

        before do
          allow(ProductSerializer).to receive(:new) do |product|
            OpenStruct.new(
              serialize: product.attributes,
              label_sort: product.id * -1
            )
          end
        end

        it 'returns the expected results' do
          expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
            [product_3.id, 1],
            [product_2.id, 2],
            [product_1.id, 3]
          ]
        end
      end
    end

    context 'when the condition\'s sorting should be used' do
      let(:manual_sort_field_description) { nil }
      let(:manual_sort_order) { nil }

      context 'when no condition sorting has been selected' do
        let(:sort_type) { Condition.sort_types.none }

        it 'returns the product hashes in the original order' do
          expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
            [product_1.id, 1],
            [product_2.id, 2],
            [product_3.id, 3]
          ]
        end
      end

      context 'when sorting randomly' do
        let(:sort_type) { Condition.sort_types.random }

        it 'returns the product hashes in a shuffled order' do
          expect(product_relation).to receive(:order).with('rand()').and_call_original
          subject.sorted_products
        end
      end

      context 'when sorting by a field' do
        let(:sort_type) { Condition.sort_types.field }

        before do
          allow(condition).to receive(:default_sort_field_name) { 'total_fat' }
          allow(condition).to receive(:default_sort_order) { sort_order }
        end

        context 'when sorting in ascending order' do
          let(:sort_order) { 'asc' }

          it 'returns the expected results' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_2.id, 1],
              [product_1.id, 2],
              [product_3.id, 3]
            ]
          end
        end

        context 'when sorting in descending order' do
          let(:sort_order) { 'desc' }

          it 'returns the expected results' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_3.id, 1],
              [product_1.id, 2],
              [product_2.id, 3]
            ]
          end
        end

        context 'when some products have nil values' do
          let!(:product_3) do
            create(:product, total_fat: nil, carbs: 6)
          end
          let(:sort_order) { 'asc' }

          it 'returns the products with nil values first' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_3.id, 1],
              [product_2.id, 2],
              [product_1.id, 3]
            ]
          end
        end
      end

      context 'when sorting by calculation' do
        let(:manual_sort_field_description) { nil }
        let(:manual_sort_order) { nil }
        let(:sort_type) { Condition.sort_types.calculation }
        let(:condition) do
          build :condition,
                sort_type: sort_type,
                sort_equation_tokens: sort_equation_tokens
        end
        let(:sort_equation_tokens) do
          [
            { type: 'variable', value: 'total_fat' },
            { type: 'operator', value: '+' },
            { type: 'variable', value: 'carbs' }
          ].to_json
        end

        context 'when all products have the relevant data' do
          it 'sorts products according to the calculation' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_2.id, 1],
              [product_1.id, 2],
              [product_3.id, 3]
            ]
          end
        end

        context 'when some products have nil values' do
          let!(:product_3) do
            create(:product, total_fat: nil, carbs: 6)
          end

          it 'sorts products according to the calculation, treating nil as 0' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_3.id, 1],
              [product_2.id, 2],
              [product_1.id, 3]
            ]
          end
        end
      end

      context 'when sorting by CustomSortings from SortFile' do
        let(:manual_sort_field_description) { nil }
        let(:manual_sort_order) { nil }
        let(:sort_type) { Condition.sort_types.file }

        context 'when custom sorts exist for session identifier for all products' do
          let!(:custom_sorting_1) do
            create(
              :custom_sorting,
              condition: condition,
              product: product_1,
              session_identifier: 'abc',
              sort_order: 2
            )
          end
          let!(:custom_sorting_2) do
            create(
              :custom_sorting,
              condition: condition,
              product: product_2,
              session_identifier: 'abc',
              sort_order: 3
            )
          end
          let!(:custom_sorting_3) do
            create(
              :custom_sorting,
              condition: condition,
              product: product_3,
              session_identifier: 'abc',
              sort_order: 1
            )
          end

          it 'sorts products according to the custom_sorts' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_3.id, 1],
              [product_1.id, 2],
              [product_2.id, 3]
            ]
          end
        end

        context 'when custom sorts exist for session identifier for some products' do
          let!(:custom_sorting_1) do
            create(
              :custom_sorting,
              condition: condition,
              product: product_1,
              session_identifier: 'abc',
              sort_order: 2
            )
          end
          let!(:custom_sorting_2) do
            create(
              :custom_sorting,
              condition: condition,
              product: product_2,
              session_identifier: 'abc',
              sort_order: 1
            )
          end

          it 'sorts products according to the custom_sorts' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_2.id, 1],
              [product_1.id, 2]
            ]
          end
        end

        context 'when sorts do not exist for session_identifier' do
          it 'returns the product hashes in the original order' do
            expect(subject.sorted_products.pluck('id', :serial_position)).to eq [
              [product_1.id, 1],
              [product_2.id, 2],
              [product_3.id, 3]
            ]
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/LetSetup
