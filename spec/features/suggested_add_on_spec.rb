# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Triggering the suggested add-on feature', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }
  let(:peanut_butter) do
    create(:product, name: 'Peanut Butter', category: category, subcategory: subcategory)
  end
  let(:jelly) do
    create(:product, name: 'Jelly', category: category, subcategory: subcategory)
  end
  let!(:mustard) do
    create(:product, name: 'Mustard', category: category, subcategory: subcategory)
  end
  let!(:product_suggestion) do
    create(
      :product_suggestion,
      condition: condition,
      product: peanut_butter,
      add_on_product: jelly
    )
  end

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  it 'shows the suggestion popup only for products with a suggested add-on', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    expect(find('.cart-count').text).to eq '0'

    # add a product that has a suggested add-on
    add_to_cart('Peanut Butter')
    expect(find('.cart-count').text).to eq '1'
    within('.suggestion-popup') do
      expect(page).to have_content 'Would you consider adding this product to your order?'
      expect(page).to have_content 'Jelly'
    end
    force_click(first('.modal-window button'))
    expect(page).not_to have_selector '.suggestion-popup'

    # add a product that doesn't have a suggested add-on
    add_to_cart('Mustard')
    expect(find('.cart-count').text).to eq '2'
    expect(page).not_to have_selector '.suggestion-popup'
  end
end
