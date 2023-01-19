# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Displaying custom attributes on cart summary', :feature do
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }

  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) do
    create(
      :condition,
      experiment: experiment,
      show_custom_attribute_on_checkout: true,
      custom_attribute_name: 'attrName',
      custom_attribute_units: 'attrUnit'
    )
  end
  let!(:custom_product_attribute) do
    create(:custom_product_attribute, condition: condition, custom_attribute_amount: 30)
  end
  let!(:foo_product) do
    create(
      :product,
      name: 'foo product',
      category: category,
      subcategory: subcategory,
      custom_product_attributes: [custom_product_attribute]
    )
  end

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  context 'when the display option is checked' do
    it 'displays the custom attribute total on checkout', :js do
      # visit store and open product
      find('.form-input').set('abc')
      force_click('input[type="submit"]')
      within(first('.product-card')) do
        force_click(find('.add-to-cart .submit'))
        force_click(find('.add-to-cart .submit'))
      end
      force_click(first('.cart-image'))
      force_click(first('.cart-checkout-bar'))
      expect(page).to have_content('Total attrName: 60 attrUnit')
    end
  end

  context 'when the display option is unchecked' do
    let(:condition) do
      create(
        :condition,
        experiment: experiment,
        show_custom_attribute_on_checkout: false,
        custom_attribute_name: 'attrName',
        custom_attribute_units: 'attrUnit'
      )
    end
    let!(:foo_product) do
      create(
        :product,
        name: 'foo product',
        category: category,
        subcategory: subcategory,
        custom_product_attributes: [custom_product_attribute]
      )
    end
    let!(:custom_product_attribute) do
      create(:custom_product_attribute, condition: condition, custom_attribute_amount: 30)
    end

    it 'doesnt display the custom attribute total on checkout', :js do
      # visit store and open product
      find('.form-input').set('abc')
      force_click('input[type="submit"]')
      within(first('.product-card')) do
        force_click(find('.add-to-cart .submit'))
        force_click(find('.add-to-cart .submit'))
      end
      force_click(first('.cart-image'))
      force_click(first('.cart-checkout-bar'))
      expect(page).not_to have_content('attrName')
      expect(page).not_to have_content('attrUnit')
    end
  end

  context 'when the display option is checked and no product has a custom attribute' do
    let!(:foo_product) do
      create(
        :product,
        name: 'foo product',
        category: category,
        subcategory: subcategory
      )
    end

    it 'displays 0 as the total amount', :js do
      # visit store and open product
      find('.form-input').set('abc')
      force_click('input[type="submit"]')
      within(first('.product-card')) do
        force_click(find('.add-to-cart .submit'))
        force_click(find('.add-to-cart .submit'))
      end
      force_click(first('.cart-image'))
      force_click(first('.cart-checkout-bar'))
      expect(page).to have_content('Total attrName: 0 attrUnit')
    end
  end
end
