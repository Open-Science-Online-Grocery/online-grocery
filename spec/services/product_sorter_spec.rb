# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSorter do
  let(:product_1) do
    { 'total_fat' => 11, 'carbs' => 5 }
  end
  let(:product_2) do
    { 'total_fat' => 2, 'carbs' => 9 }
  end
  let(:product_3) do
    { 'total_fat' => 33, 'carbs' => 6 }
  end
  let(:product_hashes) do
    [product_1, product_2, product_3]
  end
  let(:condition) { instance_double('Condition', sort_type: sort_type) }
  let(:product_sort_field) { build(:product_sort_field, name: 'carbs') }

  subject do
    described_class.new(
      product_hashes,
      condition,
      manual_sort_field_description,
      manual_sort_order
    )
  end

  before do
    allow(ProductSortField).to receive(:find_by) { product_sort_field }
  end

  describe '#sorted_products' do
    context 'when the specified manual sorting should be used' do
      let(:sort_type) { Condition.sort_types.none }
      let(:manual_sort_field_description) { 'Carbohydrates' }
      let(:manual_sort_order) { 'asc' }

      context 'when sorting in ascending order' do
        it 'returns the expected results' do
          expect(subject.sorted_products).to eq [product_1, product_3, product_2]
        end
      end

      context 'when sorting in ascending order' do
        let(:manual_sort_order) { 'desc' }

        it 'returns the expected results' do
          expect(subject.sorted_products).to eq [product_2, product_3, product_1]
        end
      end

      context 'when some products have nil values' do
        let(:product_3) do
          { 'carbs' => nil }
        end

        it 'returns the products with nil values first' do
          expect(subject.sorted_products).to eq [product_3, product_1, product_2]
        end
      end
    end

    context 'when the condition\'s default sorting should be used' do
      let(:manual_sort_field_description) { nil }
      let(:manual_sort_order) { nil }

      context 'when no default sorting has been selected' do
        let(:sort_type) { Condition.sort_types.none }

        it 'returns the product hashes in the original order' do
          expect(subject.sorted_products).to eq product_hashes
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
            expect(subject.sorted_products).to eq [product_2, product_1, product_3]
          end
        end

        context 'when sorting in ascending order' do
          let(:sort_order) { 'desc' }

          it 'returns the expected results' do
            expect(subject.sorted_products).to eq [product_3, product_1, product_2]
          end
        end

        context 'when some products have nil values' do
          let(:product_3) do
            { 'total_fat' => nil }
          end
          let(:sort_order) { 'asc' }

          it 'returns the products with nil values first' do
            expect(subject.sorted_products).to eq [product_3, product_2, product_1]
          end
        end
      end

      context 'when sorting by a calculation' do
        let(:sort_type) { Condition.sort_types.calculation }
        let(:equation) { instance_double('Equations::Sort') }

        before do
          allow(equation).to receive(:evaluate).and_return(3, 2, 1)
          allow(condition).to receive(:sort_equation) { equation }
        end

        it 'returns the expected results' do
          expect(subject.sorted_products).to eq [product_3, product_2, product_1]
        end
      end
    end
  end
end
