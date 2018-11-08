# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Configuring condition labels', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, name: 'Control', experiment: experiment) }
  let!(:label) { create(:label, name: 'Organic', built_in: true) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows label configuration', :js do
    force_click(find('.item[data-tab="labeling"]'))

    expect(find('#condition_label_type_none')).to be_checked

    expect_form_refresh do
      force_click(first('label', text: 'Use provided label'))
    end
    expect_form_refresh do
      semantic_select('Label', 'Organic')
    end

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

    expect_form_refresh do
      semantic_select('Label position', 'center')
    end

    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'

    force_click(find('.item[data-tab="labeling"]'))
    expect(find('#condition_label_type_provided')).to be_checked
    expect(page).to have_selector('.item.active', text: 'Organic')

    within('.equation-editor') do
      expect(page).to have_content 'Calories per serving>500'
    end
  end
end