# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Showing custom nutrition label styling in grocery store', :feature do
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) do
    create(
      :condition,
      experiment: experiment,
      nutrition_styles: '{".nutrition-facts-title":{"rules":{"italic":true,"fontFamily":"Comic Sans MS"}},".calories-label":{"rules":{"strikethrough":true}}}',
      nutrition_equation_tokens: [
        { 'type' => 'variable', 'value' => 'calories' },
        { 'type' => 'operator', 'value' => '<' },
        { 'type' => 'digit', 'value' => '5' }
      ].to_json
    )
  end
  let!(:styled_product) do
    create(
      :product,
      name: 'styled product',
      category: category,
      subcategory: subcategory,
      calories: 0
    )
  end
  let!(:unstyled_product) do
    create(
      :product,
      name: 'unstyled product',
      category: category,
      subcategory: subcategory,
      calories: 500
    )
  end

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  it 'styles the nutrition labels for the appropriate products', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    force_click(
      find('.product-card-name', text: 'styled product', exact_text: true)
    )
    expect(page).to have_content 'This is a product'
    expect(find('.nutrition-facts-title').native.style('font-family')).to eq '"Comic Sans MS"'
    expect(find('.nutrition-facts-title').native.style('font-style')).to eq 'italic'
    expect(find('.calories-label').native.style('text-decoration')).to match 'line-through'

    page.go_back

    force_click(
      find('.product-card-name', text: 'unstyled product', exact_text: true)
    )
    expect(page).to have_content 'This is a product'
    expect(find('.nutrition-facts-title').native.style('font-family')).not_to eq '"Comic Sans MS"'
    expect(find('.nutrition-facts-title').native.style('font-style')).not_to eq 'italic'
    expect(find('.calories-label').native.style('text-decoration')).not_to match 'line-through'
  end
end
