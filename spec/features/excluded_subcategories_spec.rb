# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Configuring hidden subcategories', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }

  let!(:category_1) { create(:category) }
  let!(:subcategory_1) { create(:subcategory, category: category_1) }
  let!(:subcategory_2) { create(:subcategory, category: category_1) }

  let!(:category_2) { create(:category) }
  let!(:subcategory_3) { create(:subcategory, category: category_2) }
  let!(:subcategory_4) { create(:subcategory, category: category_2) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows setting subcategories as shown or hidden', :js do
    force_click(find('.item[data-tab="categories"]'))

    expect(is_checked(category_1.to_s)).to be_truthy
    expect(is_checked(subcategory_1.to_s)).to be_truthy
    expect(is_checked(subcategory_2.to_s)).to be_truthy
    expect(is_checked(category_2.to_s)).to be_truthy
    expect(is_checked(subcategory_3.to_s)).to be_truthy
    expect(is_checked(subcategory_4.to_s)).to be_truthy

    expect_form_refresh do
      force_click(find('label', text: category_1.to_s))
    end

    # un-selecting the first category un-selects its subcategories, but leaves
    # other inputs unaffected.
    expect(is_checked(category_1.to_s)).to be_falsy
    expect(is_checked(subcategory_1.to_s)).to be_falsy
    expect(is_checked(subcategory_2.to_s)).to be_falsy
    expect(is_checked(category_2.to_s)).to be_truthy
    expect(is_checked(subcategory_3.to_s)).to be_truthy
    expect(is_checked(subcategory_4.to_s)).to be_truthy

    force_click(find('label', text: subcategory_4.to_s))

    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'
    expect(is_checked(category_1.to_s)).to be_falsy
    expect(is_checked(subcategory_1.to_s)).to be_falsy
    expect(is_checked(subcategory_2.to_s)).to be_falsy
    expect(is_checked(category_2.to_s)).to be_truthy
    expect(is_checked(subcategory_3.to_s)).to be_truthy
    expect(is_checked(subcategory_4.to_s)).to be_falsy

    # check its effects on the store
    visit store_path(condId: condition.uuid)
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    expect(page).to have_no_content category_1.to_s
    expect(page).to have_content category_2.to_s
    find('.top-nav .tab').hover
    expect(page).to have_content subcategory_3.to_s
    expect(page).to have_no_content subcategory_4.to_s
  end

  def is_checked(label)
    row = parent_of(find('td', text: label))
    row.has_selector?('input:checked')
  end
end
