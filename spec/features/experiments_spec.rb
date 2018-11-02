# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Experiment model CRUD', :feature do
  before do
    sign_in create(:user)
    visit root_path
  end

  it 'allows creating, updating, and deleting experiments', :js do
    force_click_on('Add Experiment')

    # invalid creation
    force_click_on('Save')
    expect(page).to have_content 'Name must have a value'

    # valid creation
    fill_in 'Name', with: 'The Best Experiment'
    force_click_on('Save')

    expect(page).to have_content 'Experiment successfully created'
    expect(page).to have_content 'The Best Experiment'

    # update
    force_click_on('Edit Experiment')
    fill_in 'Name', with: 'The Very Best Experiment'
    force_click_on('Save')

    expect(page).to have_content 'Experiment successfully updated'
    expect(page).to have_content 'The Very Best Experiment'

    # deletion
    force_click_on('Edit Experiment')
    force_click_on('Delete Experiment')
    within first('[data-modal-confirm-container]') do
      force_click(first('.ui.positive.button'))
    end

    expect(page).to have_content 'Experiment successfully deleted'
    expect(page).to have_no_content 'The Very Best Experiment'
  end
end
