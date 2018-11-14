# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Showing labels in grocery store', :feature do
  let(:label) { create(:label, name: 'Organic', built_in: true) }
  let!(:category) { create(:category) }
  let!(:subcategory) { create(:subcategory, category: category, display_order: 1) }
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) do
    create(
      :condition,
      experiment: experiment,
      label: label,
      label_position: 'top left',
      label_size: 20,
      label_equation_tokens: [
        { 'type' => 'variable', 'value' => 'calories' },
        { 'type' => 'operator', 'value' => '<' },
        { 'type' => 'digit', 'value' => '5' }
      ].to_json
    )
  end
  let!(:labeled_product) do
    create(
      :product,
      name: 'labeled product',
      category: category,
      subcategory: subcategory,
      calories: 0
    )
  end
  let!(:unlabeled_product) do
    create(
      :product,
      name: 'unlabeled product',
      category: category,
      subcategory: subcategory,
      calories: 500
    )
  end

  before do
    sign_in user
    visit store_path(condId: condition.uuid)
  end

  it 'shows the labels for the appropriate products', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    labeled_product_div = parent_of(
      find('.product-card-name', text: 'labeled product', exact_text: true)
    )
    within(labeled_product_div) do
      overlay = find('.product-card-overlay')
      expect(overlay[:style]).to match(/background-size: 20%/)
    end

    unlabeled_product_div = parent_of(
      find('.product-card-name', text: 'unlabeled product', exact_text: true)
    )
    within(unlabeled_product_div) do
      overlay = find('.product-card-overlay')
      expect(overlay[:style]).not_to match(/background-size: 20%/)
    end
  end
end
