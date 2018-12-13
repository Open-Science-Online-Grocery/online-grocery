# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Adding to cart by dollar amount', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:dollar_condition) do
    create(
      :condition,
      experiment: experiment,
      may_add_to_cart_by_dollar_amount: true
    )
  end
  let(:no_dollar_condition) do
    create(
      :condition,
      experiment: experiment,
      may_add_to_cart_by_dollar_amount: false
    )
  end
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }

  let!(:product) do
    create(
      :product,
      name: 'banana',
      category: category,
      subcategory: subcategory,
      price: 1.50
    )
  end

  before do
    sign_in user
  end

  it 'allows adding by dollar amount for the appropriate conditions', :js do
    # condition without this option enabled does not have ability to add by
    # dollar amount
    visit store_path(condId: no_dollar_condition.uuid)

    find('.form-input').set('hello')
    force_click('input[type="submit"]')
    force_click(find('.add-to-cart .selected'))

    expect(page).to have_no_content 'dollar amount'

    # condition without this option enabled DOES have ability to add by
    # dollar amount
    visit store_path(condId: dollar_condition.uuid)

    find('.form-input').set('hello')
    force_click('input[type="submit"]')
    force_click(find('.add-to-cart .selected'))

    expect(page).to have_content 'dollar amount'

    force_click(find('.option', text: 'dollar amount'))

    expect(page).to have_selector('.amount', text: '$1')
    expect(page).to have_selector('.cart-count', text: '0')

    # doesn't add to cart when set to $1
    force_click(find('.add-to-cart .submit'))
    expect(page).to have_selector('.cart-count', text: '0')

    # adds 1 to cart when set to $2
    force_click(find('.add-to-cart .increment'))
    force_click(find('.add-to-cart .submit'))
    expect(page).to have_selector('.cart-count', text: '1')

    # adds 2 to cart when set to $3
    force_click(find('.add-to-cart .increment'))
    force_click(find('.add-to-cart .submit'))
    expect(page).to have_selector('.cart-count', text: '3')
  end
end
