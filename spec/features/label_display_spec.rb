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
      label_size: 100,
      label_equation_tokens: [
        { 'type' => 'variable', 'value' => 'calories' },
        { 'type' => 'operator', 'value' => '<' },
        { 'type' => 'digit', 'value' => '5' },
      ].to_json
    )
  end
  let!(:product_1) do
    create(:product,
      category: category,
      subcategory: subcategory,
      calories: 0
    )
  end
  let!(:product_2) do
    create(:product,
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
  end
end
