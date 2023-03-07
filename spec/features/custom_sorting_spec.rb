# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Importing custom sort data for a condition', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }
  let(:bad_file) { file_fixture('sorting/bad_1.csv') }
  let(:good_file_1) { file_fixture('sorting/good_1.csv') }
  let(:good_file_2) { file_fixture('sorting/good_2.csv') }
  let!(:subcategory) { create(:subcategory) }
  let!(:product_1) { create(:product, id: 111, subcategory: subcategory) }
  let!(:product_2) { create(:product, id: 222, subcategory: subcategory) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows files to be uploaded, imported, re-uploaded, and removed', :js do
    force_click(find('.item[data-tab="sorting"]'))

    expect_form_refresh do
      force_click(first('label', text: 'A custom sort file'))
    end

    # uploading bad file
    attach_file 'condition_new_sort_file', bad_file
    force_click_on 'Save'
    expect(page).to have_content 'Unable to save condition'

    # uploading good file
    attach_file 'condition_new_sort_file', good_file_1
    force_click_on 'Save'
    expect(page).to have_content 'Condition successfully updated'
    within parent_of(find('[data-tab="sorting"] label', text: 'Current file')) do
      expect(page).to have_content File.basename(good_file_1)
    end
    expect(condition.custom_sortings.count).to eq 2

    # visit store as participant with custom sorting specified
    visit store_path(condId: condition.uuid)
    find('.form-input').set('abc')
    force_click('input[type="submit"]')
    expect(product_2.name).to appear_before(product_1.name)

    # visit store as participant without custom sorting specified
    visit store_path(condId: condition.uuid)
    find('.form-input').set('def')
    force_click('input[type="submit"]')
    expect(product_1.name).to appear_before(product_2.name)

    # back to researcher view...
    visit edit_experiment_condition_path(experiment, condition)

    # replacing file
    attach_file 'condition_new_sort_file', good_file_2
    force_click_on 'Save'
    expect(page).to have_content 'Condition successfully updated'
    within parent_of(find('[data-tab="sorting"] label', text: 'Current file')) do
      expect(page).to have_content File.basename(good_file_2)
    end
    within parent_of(find('[data-tab="sorting"] h5', text: 'Previously uploaded files')) do
      expect(page).to have_content File.basename(good_file_1)
    end
    expect(condition.custom_sortings.count).to eq 1

    # deactivating file
    force_click(find_by_id('condition_sort_files_attributes_0_active'))
    expect_form_refresh do
      force_click(first('label', text: 'Random order'))
    end
    force_click_on 'Save'
    expect(page).to have_content 'Condition successfully updated'
    within parent_of(find('[data-tab="sorting"] h5', text: 'Previously uploaded files')) do
      expect(page).to have_content File.basename(good_file_1)
      expect(page).to have_content File.basename(good_file_2)
    end
    expect(condition.custom_sortings.count).to eq 0
  end
end
