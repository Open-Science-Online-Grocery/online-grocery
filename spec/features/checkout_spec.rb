# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checking out of grocery store', :feature do
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }
  let!(:product_1) do
    create(
      :product,
      name: 'Champagne',
      category: category,
      subcategory: subcategory
    )
  end
  let!(:product_2) do
    create(
      :product,
      name: 'Brie',
      category: category,
      subcategory: subcategory
    )
  end

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  it 'creates the expected ParticipantActions', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    add_to_cart('Champagne')
    add_to_cart('Brie')

    force_click(first('.cart-image'))
    force_click(first('.cart-checkout-bar'))
    force_click(first('button.checkout-button'))

    expect(page).to have_content 'Thank You For Your Order!'

    checkout_actions = ParticipantAction.where(action_type: 'checkout')
    expect(checkout_actions.count).to eq 2
    expect(checkout_actions.first.condition).to eq condition
    expect(checkout_actions.first.session_identifier).to eq 'hello'
    expect(checkout_actions.last.condition).to eq condition
    expect(checkout_actions.last.session_identifier).to eq 'hello'
    product_ids = checkout_actions.map(&:product_id)
    expect(product_ids).to match_array [product_1.id, product_2.id]
  end
end
