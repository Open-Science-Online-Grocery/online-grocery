# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Importing suggested add-on products for a condition', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }
  let(:bad_file) { file_fixture('suggestions/bad.csv') }
  let(:good_file_1) { file_fixture('suggestions/good_1.csv') }
  let(:good_file_2) { file_fixture('suggestions/good_2.csv') }
  let!(:product_1) { create(:product, id: 1) }
  let!(:product_2) { create(:product, id: 2) }
  let!(:add_on_1) { create(:product, id: 11) }
  let!(:add_on_2) { create(:product, id: 22) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows files to be uploaded, imported, re-uploaded, and removed', :js do
    force_click(find('.item[data-tab="suggestions"]'))

    # uploading bad file
    attach_file 'condition_new_suggestion_csv_file', bad_file
    force_click_on 'Save'
    expect(page).to have_content 'Unable to save condition'

    # uploading good file
    attach_file 'condition_new_suggestion_csv_file', good_file_1
    force_click_on 'Save'
    expect(page).to have_content 'Condition successfully updated'
    within parent_of(find('[data-tab="suggestions"] label', text: 'Current file')) do
      expect(page).to have_content File.basename(good_file_1)
    end
    expect(condition.product_suggestions.count).to eq 2

    # replacing file
    attach_file 'condition_new_suggestion_csv_file', good_file_2
    force_click_on 'Save'
    expect(page).to have_content 'Condition successfully updated'
    within parent_of(find('[data-tab="suggestions"] label', text: 'Current file')) do
      expect(page).to have_content File.basename(good_file_2)
    end
    within parent_of(find('[data-tab="suggestions"] h4', text: 'Previously uploaded files')) do
      expect(page).to have_content File.basename(good_file_1)
    end
    expect(condition.product_suggestions.count).to eq 1

    # deactivating file
    force_click(find_by_id('condition_suggestion_csv_files_attributes_0_active'))
    force_click_on 'Save'
    expect(page).to have_content 'Condition successfully updated'
    within parent_of(find('[data-tab="suggestions"] h4', text: 'Previously uploaded files')) do
      expect(page).to have_content File.basename(good_file_1)
      expect(page).to have_content File.basename(good_file_2)
    end
    expect(condition.product_suggestions.count).to eq 0
  end
end
