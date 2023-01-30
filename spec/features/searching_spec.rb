# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Allowing search (or not)', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) do
    create(:condition, experiment: experiment, allow_searching: true)
  end
  let(:subcategory) { create(:subcategory, display_order: 1) }
  let!(:default_product_1) { create(:product, subcategory: subcategory) }
  let!(:default_product_2) { create(:product, subcategory: subcategory) }
  let!(:search_product_1) do
    create(:product, name: 'Honey grahams')
  end
  let!(:search_product_2) do
    create(:product, name: 'Honey Nut Cheerios')
  end

  before do
    sign_in user
  end

  it 'allows searching when condition permits', :js do
    # demonstrate that searching works by default
    visit store_path(condId: condition.uuid)
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    expect(page).to have_content(default_product_1.name)
    expect(page).to have_content(default_product_2.name)
    expect(page).to have_no_content(search_product_1.name)
    expect(page).to have_no_content(search_product_2.name)

    expect(page).to have_selector('.form-input')
    find('.search-input').set('honey')
    force_click('button[type="submit"]')

    expect(page).to have_no_content(default_product_1.name)
    expect(page).to have_no_content(default_product_2.name)
    expect(page).to have_content(search_product_1.name)
    expect(page).to have_content(search_product_2.name)

    # disallow searching on researcher side
    visit edit_experiment_condition_path(experiment, condition)
    force_click(find('.item[data-tab="searching"]'))
    expect(find_by_id('condition_allow_searching')).to be_checked
    force_click(first('label', text: 'Allow participants to search the grocery store by keyword'))

    force_click_on 'Save'
    expect(page).to have_content 'Condition successfully updated'
    expect(find_by_id('condition_allow_searching')).not_to be_checked

    # check effects in grocery store
    visit store_path(condId: condition.uuid)
    find('.form-input').set('hello')
    force_click('input[type="submit"]')
    expect(page).to have_content(default_product_1.name)
    expect(page).not_to have_selector('.search-input')
  end
end
