# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Configuring condition sorting', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }
  let!(:sort_field_1) { create(:product_sort_field, description: 'Calories', name: 'calories') }
  let!(:sort_field_2) { create(:product_sort_field, description: 'Sodium', name: 'sodium') }
  let!(:product_1) { create(:product, sodium: nil) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows sorting configuration', :js do
    force_click(find('.item[data-tab="sorting"]'))

    expect(find('#condition_sort_type_none')).to be_checked

    expect_form_refresh do
      force_click(first('label', text: 'A specified field'))
    end
    expect_form_refresh do
      semantic_select('Field', 'Calories')
    end
    semantic_select('Order', 'Descending')
    expect(page).to have_no_content 'Warning: Incomplete data'

    expect_form_refresh do
      semantic_select('Field', 'Sodium')
    end
    expect(page).to have_content 'Warning: Incomplete data'

    semantic_select('Allow participants to sort products by:', 'Calories')
    semantic_select('Allow participants to sort products by:', 'Sodium')

    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'
    expect(page).to have_selector('[data-tab="sorting"] .item.active', text: 'Calories')
    expect(page).to have_selector('[data-tab="sorting"] .item.active', text: 'Descending')
    expect(page).to have_selector('[data-tab="sorting"] .ui.label', text: 'Calories')
    expect(page).to have_selector('[data-tab="sorting"] .ui.label', text: 'Sodium')

    expect_form_refresh do
      force_click(first('label', text: 'The following calculation'))
    end

    within('[data-tab="sorting"] div.calculator') do
      force_click_on('5')
      force_click_on('Test Calculation')
      expect(page).to have_content 'This calculation is valid'
    end

    force_click_on 'Save'
    expect(page).to have_content 'Condition successfully updated'
    expect(page).to have_no_selector('[data-tab="sorting"] .item.active:not(.filtered)', text: 'Calories')
    expect(page).to have_no_selector('[data-tab="sorting"] .item.active:not(.filtered)', text: 'Descending')
  end
end
