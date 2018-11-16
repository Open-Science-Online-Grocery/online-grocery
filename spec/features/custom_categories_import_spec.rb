# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Importing custom categories for a condition', :feature do
  let(:full_file_path) { Rails.root.join(file_fixture(file_with_path)) }
  let(:file_with_path) { "tag_imports/#{file_name}" }
  let(:file_name) { 'custom_categories_valid.csv' }
  let(:full_file_path_2) { Rails.root.join(file_fixture(file_with_path_2)) }
  let(:file_with_path_2) { "tag_imports/#{file_name_2}" }
  let(:file_name_2) { 'custom_categories_valid_2.csv' }
  let(:condition) { create :condition }
  let(:user) { create(:user) }

  # rubocop:disable RSpec/BeforeAfterAll
  before :all do
    DatabaseCleaner.strategy = [:truncation, pre_count: true]
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :transaction

    category_1 = Category.create!(name: 'Category 1')
    subcategory_1 = Subcategory.create!(name: 'Subcategory 1', category: category_1)
    Product.create!(
      id: 98,
      name: 'Product 1',
      category_id: category_1.id,
      subcategory_id: subcategory_1.id
    )

    category_2 = Category.create!(name: 'Category 2')
    subcategory_2 = Subcategory.create!(name: 'Subcategory 2', category: category_2)
    Product.create!(
      id: 99,
      name: 'Product 2',
      category_id: category_2.id,
      subcategory_id: subcategory_2.id
    )
  end

  after :all do
    DatabaseCleaner.strategy = [:truncation, pre_count: true]
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :transaction
  end
  # rubocop:enable RSpec/BeforeAfterAll

  before do
    sign_in user
    visit edit_experiment_condition_path(
      experiment_id: condition.experiment.id,
      id: condition.id,
      tab: 'categories'
    )
  end

  it 'allows files to be uploaded, imported, re-uploaded, and removed', :js do
    # upload csv
    attach_file 'condition_csv_file', full_file_path
    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'

    within('[data-current-csv]') do
      expect(page).to have_content file_name
    end

    expect(page).to have_content 'Custom Category 1A'
    expect(page).to have_content 'Custom Subcategory 1A'
    expect(page).to have_content 'Custom Category 2A'
    expect(page).to have_content 'Custom Subcategory 2A'
    expect(page).to have_content 'Custom Category 1B'
    expect(page).to have_content 'Custom Subcategory 1B'
    expect(page).to have_content 'Custom Category 2B'
    expect(page).to have_content 'Custom Subcategory 2B'

    # reupload a new csv
    attach_file 'condition_csv_file', full_file_path_2
    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'

    within('[data-current-csv]') do
      expect(page).to have_content file_name_2
    end

    within('[data-historical-csvs]') do
      expect(page).to have_content file_name
    end

    expect(page).to have_content 'Custom Category 1C'
    expect(page).to have_content 'Custom Subcategory 1C'
    expect(page).to have_content 'Custom Category 2C'
    expect(page).to have_content 'Custom Subcategory 2C'
    expect(page).to have_content 'Custom Category 1D'
    expect(page).to have_content 'Custom Subcategory 1D'
    expect(page).to have_content 'Custom Category 2D'
    expect(page).to have_content 'Custom Subcategory 2D'

    # remove csv
    force_click(find('#condition_active_tag_csv').find(:xpath, '../..'))
    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'

    within('[data-current-csv]') do
      expect(page).to have_no_content file_name
      expect(page).to have_no_content file_name_2
    end

    within('[data-historical-csvs]') do
      expect(page).to have_content file_name
      expect(page).to have_content file_name_2
    end

    expect(page).to have_no_content 'Custom Category'
    expect(page).to have_no_content 'Custom Subcategory'
  end
end
