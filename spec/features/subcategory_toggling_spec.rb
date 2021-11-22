# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Showing/hiding subcategory navigation', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }

  let!(:category_1) { create(:category) }
  let!(:subcategory_1) { create(:subcategory, category: category_1) }
  let!(:subcategory_2) { create(:subcategory, category: category_1) }

  let!(:category_2) { create(:category) }
  let!(:subcategory_3) { create(:subcategory, category: category_2) }

  let!(:product_1) do
    create(:product, category: category_1, subcategory: subcategory_1)
  end
  let!(:product_2) do
    create(:product, category: category_1, subcategory: subcategory_2)
  end
  let!(:product_3) do
    create(:product, category: category_2, subcategory: subcategory_3)
  end

  before do
    sign_in user
  end

  it 'allows setting subcategories as shown or hidden', :js do
    visit store_path(condId: condition.uuid)
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    # only first subcategory is shown
    expect(page).to have_content product_1.name
    expect(page).to have_no_content product_2.name
    expect(page).to have_no_content product_3.name

    # demonstrate that users can't navigate products by category (only subcategory)
    force_click(find('.tab div', text: category_2.to_s))
    expect(page).to have_content product_1.name
    expect(page).to have_no_content product_2.name
    expect(page).to have_no_content product_3.name

    find('.tab div', text: category_1.to_s).hover
    expect(page).to have_content subcategory_1.to_s
    expect(page).to have_content subcategory_2.to_s
    force_click(find('.tab-subcat-title', text: subcategory_2.to_s))

    expect(page).to have_no_content product_1.name
    expect(page).to have_content product_2.name

    visit edit_experiment_condition_path(experiment, condition)
    force_click(find('.item[data-tab="categories"]'))

    force_click find('label', text: 'Organize products by subcategory')
    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'
    visit store_path(condId: condition.uuid)
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    # products from both subcategories of category_1 are shown
    expect(page).to have_content product_1.name
    expect(page).to have_content product_2.name
    expect(page).to have_no_content product_3.name

    find('.tab div', text: category_1.to_s).hover
    expect(page).to have_no_content subcategory_1.to_s
    expect(page).to have_no_content subcategory_2.to_s

    # demonstrate that users can navigate products by category
    force_click(find('.tab div', text: category_2.to_s))
    expect(page).to have_no_content product_1.name
    expect(page).to have_no_content product_2.name
    expect(page).to have_content product_3.name
  end
end
