# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Configuring condition labels', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }
  let!(:label) { create(:label, name: 'Organic', built_in: true) }
  let!(:product) { create(:product, sodium: nil) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows label configuration', :js do
    expect(page).to have_content 'Edit Condition'
    force_click(find('.item[data-tab="labeling"]'))
    within '.tab.segment[data-tab="labeling"]' do
      force_click(find('a.add_fields'))
    end

    expect(first('label', text: 'Use custom label').sibling('input')).to be_checked

    expect_form_refresh do
      force_click(previous_sibling_of(first('label', text: 'Use provided label')))
    end
    expect_form_refresh do
      semantic_select('Label', 'Organic')
    end

    within('[data-tab="labeling"] div.calculator') do
      force_click find('.ui.selection.dropdown')

      force_click find('div.item', text: 'Sodium per serving (mg)', exact_text: true)
      force_click_on('Insert field')
      expect(page).to have_content 'Warning: Not all products have information for the following fields.'

      force_click(first('.arrow.left.icon'))
      expect(page).to have_no_content 'Warning: Not all products have information for the following fields.'

      force_click find('div.item', text: 'Calories per serving', exact_text: true)
      force_click_on('Insert field')

      force_click_on('Test Calculation')

      expect(page).to have_content 'This calculation is invalid'

      force_click_on('>')
      force_click_on('5')
      force_click_on('0')
      force_click_on('0')

      force_click_on('Test Calculation')
      expect(page).to have_content 'This calculation is valid'
    end

    expect_form_refresh do
      semantic_select('Position', 'center')
    end

    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'

    force_click(find('.item[data-tab="labeling"]'))
    expect(first('label', text: 'Use provided label').sibling('input')).to be_checked
    expect(page).to have_selector('.item.active', text: 'Organic')

    within('[data-tab="labeling"] .equation-editor') do
      expect(page).to have_content 'Calories per serving>500'
    end
  end
end
