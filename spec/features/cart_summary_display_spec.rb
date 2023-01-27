# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Showing cart summary information', :feature do
  let(:cart_label_1) do
    create(
      :cart_summary_label,
      name: 'Thumbs up',
      image: File.open('spec/support/thumbs-up.png')
    )
  end
  let(:cart_label_2) do
    create(
      :cart_summary_label,
      name: 'Gold star',
      image: File.open('spec/support/gold-star.png')
    )
  end
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) do
    create(
      :condition,
      experiment: experiment,
      food_count_format: 'ratio'
    )
  end
  let!(:condition_cart_label_1) do
    create(
      :condition_cart_summary_label,
      condition: condition,
      always_show: true,
      cart_summary_label: cart_label_1
    )
  end
  let!(:condition_cart_label_2) do
    create(
      :condition_cart_summary_label,
      condition: condition,
      always_show: false,
      cart_summary_label: cart_label_2,
      equation_tokens: [
        { 'type' => 'variable', 'value' => 'avg_calories' },
        { 'type' => 'operator', 'value' => '>' },
        { 'type' => 'digit', 'value' => '1' },
        { 'type' => 'digit', 'value' => '0' }
      ].to_json
    )
  end
  let(:label) { create(:label, name: 'Foo') }
  let!(:condition_label) do
    create(
      :condition_label,
      label: label,
      condition: condition,
      equation_tokens: [
        { 'type' => 'variable', 'value' => 'calories' },
        { 'type' => 'operator', 'value' => '>' },
        { 'type' => 'digit', 'value' => '1' },
        { 'type' => 'digit', 'value' => '0' }
      ].to_json
    )
  end

  let!(:low_cal_product) do
    create(
      :product,
      name: 'low_cal product',
      category: category,
      subcategory: subcategory,
      calories: 0
    )
  end
  let!(:high_cal_product) do
    create(
      :product,
      name: 'high_cal product',
      category: category,
      subcategory: subcategory,
      calories: 500
    )
  end

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  it 'shows the cart labels under the appropriate conditions', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    low_cal_product_div = parent_of(
      parent_of(
        find('.product-card-name', text: 'low_cal product', exact_text: true)
      )
    )
    within(low_cal_product_div) do
      force_click(find('.add-to-cart .submit'))
    end

    force_click(first('.cart-image'))
    force_click(first('.cart-checkout-bar'))
    expect(page).to have_css("img[src*='thumbs-up.png']")
    expect(page).not_to have_css("img[src*='gold-star.png']")
    expect(page).to have_content('0 out of 1 products have the Foo label')

    page.go_back

    high_cal_product_div = parent_of(
      parent_of(
        find('.product-card-name', text: 'high_cal product', exact_text: true)
      )
    )
    within(high_cal_product_div) do
      force_click(find('.add-to-cart .submit'))
    end

    force_click(first('.cart-image'))
    force_click(first('.cart-checkout-bar'))
    expect(page).to have_css("img[src*='thumbs-up.png']")
    expect(page).to have_css("img[src*='gold-star.png']")
    expect(page).to have_content('1 out of 2 products has the Foo label')
  end
end
