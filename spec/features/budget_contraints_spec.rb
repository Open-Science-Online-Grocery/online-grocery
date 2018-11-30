# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Using budget constraints in grocery store', :feature do
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) do
    create(
      :condition,
      experiment: experiment,
      minimum_spend: 4,
      maximum_spend: 11
    )
  end
  let!(:product_1) do
    create(
      :product,
      name: 'Champagne',
      category: category,
      subcategory: subcategory,
      price: 10
    )
  end
  let!(:product_2) do
    create(
      :product,
      name: 'Brie',
      category: category,
      subcategory: subcategory,
      price: 5
    )
  end

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  it 'alerts and prevents checkout unless budget constraints are met', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    add_to_cart('Champagne')
    add_to_cart('Brie')

    expect(page).to have_content 'Your cart is now over your maximum budget.'

    force_click(first('.modal-window button'))
    force_click(first('.cart-image'))
    force_click(first('.cart-checkout-bar'))

    expect(page).to have_content 'In order to check out, you must spend less than $11.00.'
    expect(page).to have_css '.checkout-button.disabled'

    force_click(first('.order-delete-item'))

    expect(page).to have_no_content 'In order to check out, you must spend less than $11.00.'
    expect(page).to have_no_css '.checkout-button.disabled'

    force_click(first('.order-delete-item'))

    expect(page).to have_content 'Your cart is now under your minimum budget.'

    force_click(first('.modal-window button'))

    expect(page).to have_content 'In order to check out, you must spend more than $4.00.'
    expect(page).to have_css '.checkout-button.disabled'
  end

  def add_to_cart(product_name)
    product_div = parent_of(
      parent_of(
        find('.product-card-name', text: product_name, exact_text: true)
      )
    )
    within(product_div) do
      force_click(find('.product-card-add-to-cart'))
    end
  end
end
