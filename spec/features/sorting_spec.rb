# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sorting products in grocery store', :feature do
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }
  let(:sort_field) { create(:product_sort_field, name: 'calories') }
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) do
    create(
      :condition,
      experiment: experiment,
      default_sort_field: sort_field,
      default_sort_order: 'desc'
    )
  end
  let!(:product_1) { create(:product, calories: 200, name: 'Popcorn') }
  let!(:product_2) { create(:product, calories: 300, name: 'Pop Tarts') }
  let!(:product_3) { create(:product, calories: 100, name: 'Soda Pop') }

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  it 'shows products in the order specified by the condition', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    # search for products
    find('.form-input').set('pop')
    force_click('button[type="submit"]')

    expect(page).to have_content 'Search Results'
    expect(product_2.name).to appear_before(product_1.name)
    expect(product_2.name).to appear_before(product_3.name)
    expect(product_1.name).to appear_before(product_3.name)
  end
end
