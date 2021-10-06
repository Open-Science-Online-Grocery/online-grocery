# frozen_string_literal: true

require 'rails_helper'

# due to the amount of query logic in this class, this spec functions more like
# an integration test (doing actual db lookups) rather than a unit test.
# rubocop:disable RSpec/InstanceVariable, RSpec/BeforeAfterAll
RSpec.describe ProductFetcher do
  let(:condition) { Condition.new }

  subject { described_class.new(condition, params) }

  before(:all) do
    @beverages = create(:category, name: 'Beverages')
    dry_goods = create(:category, name: 'Dry Goods')

    @breakfast_foods = create(
      :subcategory,
      name: 'Breakfast Foods',
      category: dry_goods
    )
    @soft_drinks = create(
      :subcategory,
      name: 'Soft Drinks',
      category: @beverages
    )

    @caffeine_free = create(
      :subsubcategory,
      name: 'Caffeine Free',
      subcategory: @soft_drinks
    )

    @pop_tarts = create(
      :product,
      name: 'Pop Tarts',
      category: dry_goods,
      subcategory: @breakfast_foods
    )
    @orange_juice = create(
      :product,
      name: 'Orange Juice',
      category: @beverages
    )
    @soda_pop = create(
      :product,
      name: 'Soda Pop',
      category: @beverages,
      subcategory: @soft_drinks
    )
    @ginger_ale = create(
      :product,
      name: 'Ginger Ale',
      category: @beverages,
      subcategory: @soft_drinks,
      subsubcategory: @caffeine_free
    )

    @on_sale = create(:tag, name: 'On Sale')
    @clearance = create(:subtag, name: 'Clearance', tag: @on_sale)

    create(:product_tag, product: @pop_tarts, tag: @on_sale, subtag: @clearance)
    create(:product_tag, product: @ginger_ale, tag: @on_sale, subtag: @clearance)
    create(:product_tag, product: @orange_juice, tag: @on_sale)
  end

  after(:all) do
    clean_with_deletion
  end

  before do
    allow(ProductSerializer).to receive(:new) do |product, _condition|
      instance_double(
        'ProductSerializer',
        serialize: product
      )
    end
    allow(ProductSorter).to receive(:new) do |product_hashes, _condition, _sort_field, _sort_direction|
      instance_double(
        'ProductSorter',
        sorted_products: product_hashes
      )
    end
  end

  describe '#fetch_products' do
    context 'when searching by a search term' do
      let(:params) do
        {
          search_type: 'term',
          search_term: 'pop',
          sort_field: 'foo',
          sort_direction: 'bar'
        }
      end

      it 'returns the expected products' do
        expect(subject.fetch_products).to match_array [@pop_tarts, @soda_pop]
        expect(ProductSerializer).to have_received(:new).with(@pop_tarts, condition)
        expect(ProductSerializer).to have_received(:new).with(@soda_pop, condition)
        expect(ProductSorter).to have_received(:new).with(
          [@pop_tarts, @soda_pop],
          condition,
          'foo',
          'bar'
        )
      end

      context 'with excluded subcategories' do
        before do
          allow(condition).to receive(:excluded_subcategory_ids) do
            [@breakfast_foods.id]
          end
        end

        it 'does not return products from excluded subcategories' do
          expect(subject.fetch_products).to match_array [@soda_pop]
        end
      end
    end

    describe 'category searches' do
      let(:params) do
        {
          selected_category_type: 'category',
          selected_category_id: @beverages.id
        }
      end

      context 'when searching by category only' do
        before do
          allow(condition).to receive(:show_products_by_subcategory) { false }
        end

        it 'returns the expected products' do
          expect(subject.fetch_products).to match_array [@orange_juice, @soda_pop, @ginger_ale]
        end

        context 'with excluded subcategories' do
          before do
            allow(condition).to receive(:excluded_subcategory_ids) do
              [@soft_drinks.id]
            end
          end

          it 'does not return products from excluded subcategories' do
            expect(subject.fetch_products).to match_array [@orange_juice]
          end
        end

        context 'when filtering by tag' do
          before do
            params[:selected_filter_type] = 'subtag'
            params[:selected_filter_id] = @clearance.id
          end

          it 'only returns products with the specified tag' do
            expect(subject.fetch_products).to match_array [@ginger_ale]
          end
        end

        context 'when filtering by subtag' do
          before do
            params[:selected_filter_type] = 'tag'
            params[:selected_filter_id] = @on_sale.id
          end

          it 'only returns products with the specified tag' do
            expect(subject.fetch_products).to match_array [@orange_juice, @ginger_ale]
          end
        end
      end

      context 'when searching by subcategory' do
        before do
          allow(condition).to receive(:show_products_by_subcategory) { true }
          params[:selected_subcategory_id] = @soft_drinks.id
        end

        it 'returns the expected products' do
          expect(subject.fetch_products).to match_array [@soda_pop, @ginger_ale]
        end

        context 'with excluded subcategories' do
          before do
            allow(condition).to receive(:excluded_subcategory_ids) do
              [@soft_drinks.id]
            end
          end

          it 'does not return products from excluded subcategories' do
            expect(subject.fetch_products).to match_array []
          end
        end
      end

      context 'when searching by subsubcategory' do
        before do
          allow(condition).to receive(:show_products_by_subcategory) { true }
          params[:selected_subsubcategory_id] = @caffeine_free.id
        end

        it 'returns the expected products' do
          expect(subject.fetch_products).to match_array [@ginger_ale]
        end

        context 'with excluded subcategories' do
          before do
            allow(condition).to receive(:excluded_subcategory_ids) do
              [@soft_drinks.id]
            end
          end

          it 'does not return products from excluded subcategories' do
            expect(subject.fetch_products).to match_array []
          end
        end
      end
    end

    describe 'tag searches' do
      let(:params) do
        {
          selected_category_type: 'tag',
          selected_category_id: @on_sale.id
        }
      end

      context 'when searching by tag only' do
        before do
          allow(condition).to receive(:show_products_by_subcategory) { false }
        end

        it 'returns the expected products' do
          expect(subject.fetch_products).to match_array [@pop_tarts, @ginger_ale, @orange_juice]
        end

        context 'with excluded subcategories' do
          before do
            allow(condition).to receive(:excluded_subcategory_ids) do
              [@soft_drinks.id]
            end
          end

          it 'does not return products from excluded subcategories' do
            expect(subject.fetch_products).to match_array [@pop_tarts, @orange_juice]
          end
        end
      end

      context 'when searching by subtag' do
        before do
          allow(condition).to receive(:show_products_by_subcategory) { true }
          params[:selected_subcategory_id] = @clearance.id
        end

        it 'returns the expected products' do
          expect(subject.fetch_products).to match_array [@pop_tarts, @ginger_ale]
        end

        context 'with excluded subcategories' do
          before do
            allow(condition).to receive(:excluded_subcategory_ids) do
              [@soft_drinks.id]
            end
          end

          it 'does not return products from excluded subcategories' do
            expect(subject.fetch_products).to match_array [@pop_tarts]
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/InstanceVariable, RSpec/BeforeAfterAll
