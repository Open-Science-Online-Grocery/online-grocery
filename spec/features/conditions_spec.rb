# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Condition model CRUD', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user, name: 'foo') }

  before do
    sign_in user
    visit experiment_path(experiment)
  end

  it 'allows creating, updating, and deleting conditions', :js do
    expect(page).to have_content 'You have not yet added any conditions'

    force_click_on('Add Condition')

    # invalid creation
    force_click_on('Save')
    expect(page).to have_content 'Condition name must have a value'
    expect(page).to have_content 'Qualtrics code must have a value'

    # valid creation
    fill_in 'Condition name', with: 'Control'
    fill_in 'Qualtrics code', with: 'ABCDEFG'
    force_click_on('Save')

    expect(page).to have_content 'Condition successfully created'
    expect(page).to have_content 'Control'
    expect(page).to have_content 'URL for this condition'

    # update
    fill_in 'Condition name', with: 'Control Group'
    force_click_on('Save')

    expect(page).to have_content 'Condition successfully updated'
    expect(page).to have_content 'Control Group'

    # deletion
    force_click_on('Delete Condition')
    within first('[data-modal-confirm-container]') do
      force_click(first('.ui.positive.button'))
    end

    expect(page).to have_content 'Condition successfully deleted'
    expect(page).to have_no_content 'Control Group'
  end
end
