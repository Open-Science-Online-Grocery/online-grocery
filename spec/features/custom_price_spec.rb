# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Importing custom product prices for a condition', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }
  let(:bad_file) { file_fixture('sorting/bad_1.csv') }
  let(:good_file) { file_fixture('product_prices/good.csv') }

  let!(:subcategory) { create(:subcategory) }
  let!(:product_1) { create(:product, id: 1, subcategory: subcategory) }
  let!(:product_2) { create(:product, id: 2, subcategory: subcategory) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows files to be uploaded, imported, re-uploaded, and removed', :js do
    force_click(find('.item[data-tab="custom-attribute"]'))

    expect_form_refresh do
      # uploading bad file
      attach_file 'condition_new_product_price_file', bad_file
      force_click_on 'Save'
      expect(page).to have_content 'Unable to save condition'

      # uploading good file
      attach_file 'condition_new_product_price_file', good_file
      force_click_on 'Save'
      expect(page).to have_content 'Condition successfully updated'
      within parent_of(find('[data-tab="custom-attribute"] label.custom-price', text: 'Current file')) do
        expect(page).to have_content File.basename(good_file)
      end
    end

    # visit store and open product
    visit store_path(condId: condition.uuid)
    find('.form-input').set('abc')
    force_click('input[type="submit"]')
    within(first('.product-card')) do
      force_click(first('a'))
    end
    expect(page).to have_content('999')
  end
end
