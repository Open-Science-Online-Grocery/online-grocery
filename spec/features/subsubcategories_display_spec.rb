# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Scoping products by subsubcategories', :feature do
  let(:user) { create(:user) }
  let!(:category_1) { create(:category) }
  let!(:category_2) { create(:category) }
  let!(:subcategory) do
    create(
      :subcategory,
      category: category_1,
      display_order: 1,
      name: 'Foo'
    )
  end
  let!(:subsubcategory_1) do
    create(
      :subsubcategory,
      subcategory: subcategory,
      display_order: 1,
      name: 'AAA'
    )
  end
  let!(:subsubcategory_2) do
    create(
      :subsubcategory,
      subcategory: subcategory,
      display_order: 2,
      name: 'BBB'
    )
  end
  let!(:product_1) do
    create(
      :product,
      name: 'Champagne',
      category: category_1,
      subcategory: subcategory,
      subsubcategory: subsubcategory_1
    )
  end
  let!(:product_2) do
    create(
      :product,
      name: 'Brie',
      category: category_1,
      subcategory: subcategory,
      subsubcategory: subsubcategory_2
    )
  end

  before do
    sign_in user
    visit store_path
  end

  it 'allows scoping by sub-sub-categories', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    expect(page).to have_content 'Champagne'
    expect(page).to have_content 'Brie'

    first('div.tab').hover
    find('.tab-subcat-title', text: 'Foo').hover
    force_click(find('.tab-subsubcat', text: 'AAA'))

    expect(page).to have_content 'Champagne'
    expect(page).to have_no_content 'Brie'

    force_click(find('.tab-subsubcat', text: 'BBB'))

    expect(page).to have_no_content 'Champagne'
    expect(page).to have_content 'Brie'
  end
end
