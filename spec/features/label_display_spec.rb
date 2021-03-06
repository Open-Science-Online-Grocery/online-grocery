# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Showing labels in grocery store', :feature do
  let(:label_1) { create(:label, name: 'Organic', built_in: true) }
  let(:label_2) { create(:label, name: 'Low Fat', built_in: true) }
  let(:label_3) { create(:label, name: 'Unsweetened', built_in: true) }
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) do
    create(
      :condition,
      experiment: experiment
    )
  end
  let!(:overlay_label_1) do
    create :condition_label,
           condition: condition,
           label: label_1,
           position: 'top left',
           size: 20,
           equation_tokens: [
             { 'type' => 'variable', 'value' => 'calories' },
             { 'type' => 'operator', 'value' => '<' },
             { 'type' => 'digit', 'value' => '5' }
           ].to_json
  end
  let!(:overlay_label_2) do
    create :condition_label,
           condition: condition,
           label: label_2,
           position: 'bottom right',
           size: 25,
           equation_tokens: [
             { 'type' => 'variable', 'value' => 'total_fat' },
             { 'type' => 'operator', 'value' => '<' },
             { 'type' => 'digit', 'value' => '20' }
           ].to_json
  end
  let!(:below_button_label) do
    create :condition_label,
           condition: condition,
           label: label_3,
           position: ConditionLabel.below_button_position,
           size: 30,
           equation_tokens: [
             { 'type' => 'variable', 'value' => 'total_fat' },
             { 'type' => 'operator', 'value' => '>' },
             { 'type' => 'digit', 'value' => '20' }
           ].to_json
  end
  let!(:labeled_product) do
    create(
      :product,
      name: 'labeled product',
      category: category,
      subcategory: subcategory,
      calories: 0,
      total_fat: 0
    )
  end
  let!(:unlabeled_product) do
    create(
      :product,
      name: 'unlabeled product',
      category: category,
      subcategory: subcategory,
      calories: 500,
      total_fat: 30
    )
  end

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  it 'shows the labels for the appropriate products', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    first_product_div = parent_of(
      find('.product-card-name', text: 'labeled product', exact_text: true)
    )
    within(first_product_div) do
      overlays = find_all('.overlay-label')
      overlay_1 = overlays[0]
      overlay_2 = overlays[1]
      expect(overlay_1[:style]).to match(/background-size: 20%/)
      expect(overlay_2[:style]).to match(/background-size: 25%/)
    end
    expect(parent_of(first_product_div)).to have_no_selector '.below-button-container img'

    second_product_div = parent_of(
      find('.product-card-name', text: 'unlabeled product', exact_text: true)
    )

    # this product should not have any overlays rendered
    expect(second_product_div).to have_no_selector '.overlay-label'

    within(parent_of(second_product_div)) do
      below_button_label = first('.below-button-container img')
      expect(below_button_label[:style]).to match(/width: 30%/)
    end
  end
end
