# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Configuring condition budgeting settings', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows budgeting configuration', :js do
    force_click(find('.item[data-tab="budgeting"]'))

    expect(find('#condition_may_add_to_cart_by_dollar_amount')).not_to be_checked

    force_click(first('label', text: 'Allow participants to add items to cart by dollar amount'))
    fill_in('Participants must spend at least', with: 10)
    fill_in('Participants must not spend more than', with: 50)

    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'
    expect(find('#condition_may_add_to_cart_by_dollar_amount')).to be_checked

    expect(page).to have_selector("input[value='10.00']")
    expect(page).to have_selector("input[value='50.00']")
  end
end
