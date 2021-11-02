# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Showing custom category tab and filter dropdown in grocery store', :feature do
  let(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }
  let(:tag_1) { create(:tag, name: 'Tag 1') }
  let!(:subtag_1) { create(:subtag, tag: tag_1, name: 'Subtag 1') }
  let(:tag_2) { create(:tag, name: 'Tag 2') }
  let!(:subtag_2) { create(:subtag, tag: tag_2, name: 'Subtag 2') }
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) do
    create(
      :condition,
      experiment: experiment,
      filter_by_custom_categories: true
    )
  end
  let(:product_1) do
    create(
      :product,
      category: category,
      subcategory: subcategory,
      name: 'Product 1'
    )
  end
  let(:product_2) do
    create(
      :product,
      category: category,
      subcategory: subcategory,
      name: 'Product 2'
    )
  end
  let!(:product_tag_1) do
    create(
      :product_tag,
      condition: condition,
      product: product_1,
      tag: tag_1,
      subtag: subtag_1
    )
  end
  let!(:product_tag_2) do
    create(
      :product_tag,
      condition: condition,
      product: product_2,
      tag: tag_2,
      subtag: subtag_2
    )
  end

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  it 'shows the labels for the appropriate products', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    # site-wide filtering
    expect(page).to have_content 'Filter by:'
    expect(page).to have_content 'Product 1'
    expect(page).to have_content 'Product 2'

    select('Subtag 1', from: 'product-filter-select')

    expect(page).to have_content 'Product 1'
    expect(page).to have_no_content 'Product 2'

    select('None', from: 'product-filter-select')

    expect(page).to have_content 'Product 1'
    expect(page).to have_content 'Product 2'

    # custom category tab
    within('.top-nav .menu') do
      expect(page).to have_content 'Tag 1'
      expect(page).to have_no_content 'Tag 2'
    end

    find('.tab', text: 'Tag 1').hover
    find('.tab-dropdown', text: 'Subtag 1').click

    expect(page).to have_content 'Product 1'
    expect(page).to have_no_content 'Product 2'
  end
end
