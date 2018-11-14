# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Configuring the cart summary', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, name: 'Control', experiment: experiment) }
  let!(:cart_summary_label) { create(:cart_summary_label, name: 'Organic', built_in: true) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows cart summary label configuration', :js do
    force_click(find('.item[data-tab="cart-summary"]'))

    expect(find('#condition_show_price_total')).to be_checked
    expect(find('#condition_show_food_count')).not_to be_checked

    expect_form_refresh do
      force_click(first('label', text: 'Show count of foods with health labels'))
    end
    force_click(first('label', text: 'Show as percent ("40% of products")'))

    within('.tab.segment[data-tab="cart-summary"]') do
      expect(page).to have_no_content 'Use custom label'
    end
    force_click_on('Add another cart summary label')

    within(first('[data-cart-summary-label]')) do
      expect(first('label', text: 'Use custom label').sibling('input', visible: false)).to be_checked
      expect(first('label', text: 'Use provided label').sibling('input', visible: false)).not_to be_checked
    end
    expect_form_refresh do
      within(first('[data-cart-summary-label]')) do
        force_click(first('label', text: 'Use provided label'))
      end
    end
    within(first('[data-cart-summary-label]')) do
      expect(first('label', text: 'Use custom label').sibling('input', visible: false)).not_to be_checked
      expect(first('label', text: 'Use provided label').sibling('input', visible: false)).to be_checked
    end

    # TODO: Add `expect_form_refresh` here when preview is working
    semantic_select('Cart summary label', 'Organic')

    expect_form_refresh do
      within(first('[data-cart-summary-label]')) do
        force_click(first('label', text: 'Show this image only for carts where:'))
      end
    end

    within(first('[data-cart-summary-label]')) do
      expect(page).to have_content 'Test Calculation'
      within('div.calculator') do
        force_click find('.ui.selection.dropdown')
        force_click find('div.item', text: 'Calories per serving', exact_text: true)
        force_click_on('Insert field into calculation')

        force_click_on('Test Calculation')

        expect(page).to have_content 'This calculation is invalid'

        force_click_on('>')
        force_click_on('5')
        force_click_on('0')
        force_click_on('0')

        force_click_on('Test Calculation')
        expect(page).to have_content 'This calculation is valid'
      end
    end

    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'

    force_click(find('.item[data-tab="cart-summary"]'))
    within(first('[data-cart-summary-label]')) do
      expect(first('label', text: 'Use provided label').sibling('input', visible: false)).to be_checked
      expect(page).to have_selector('.item.active', text: 'Organic')

      within('.equation-editor') do
        expect(page).to have_content 'Calories per serving>500'
      end
    end
  end
end
