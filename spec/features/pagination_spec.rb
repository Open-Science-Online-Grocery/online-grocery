# frozen_string_literal: true

require 'rails_helper'

# this is needed so that the `stub_const` below doesn't overwrite Paginator
# with an empty module. see https://github.com/rspec/rspec-mocks/issues/1079
require 'paginator'

RSpec.describe 'Paginating products in grocery store', :feature do
  let(:category) { create(:category) }
  let(:subcategory) do
    create(:subcategory, category: category, display_order: 1)
  end
  let!(:products) { create_list(:product, 7, subcategory: subcategory) }
  let!(:condition) { create(:condition) }

  before do
    stub_const('Paginator::RECORDS_PER_PAGE', 3)
    visit store_path(condId: condition.uuid)
  end

  it 'distributes the products across different pages', :js do
    find('.form-input').set('hello')
    force_click('input[type="submit"]')

    expect(page).to have_content(products[0].name)
    expect(page).to have_content(products[1].name)
    expect(page).to have_content(products[2].name)
    expect(page).to have_no_content(products[3].name)
    expect(page).to have_no_content(products[4].name)
    expect(page).to have_no_content(products[5].name)
    expect(page).to have_no_content(products[6].name)

    force_click(find('.pagination a', text: '>'))

    expect(page).to have_no_content(products[0].name)
    expect(page).to have_no_content(products[1].name)
    expect(page).to have_no_content(products[2].name)
    expect(page).to have_content(products[3].name)
    expect(page).to have_content(products[4].name)
    expect(page).to have_content(products[5].name)
    expect(page).to have_no_content(products[6].name)

    force_click(find('.pagination a', text: '3'))

    expect(page).to have_no_content(products[0].name)
    expect(page).to have_no_content(products[1].name)
    expect(page).to have_no_content(products[2].name)
    expect(page).to have_no_content(products[3].name)
    expect(page).to have_no_content(products[4].name)
    expect(page).to have_no_content(products[5].name)
    expect(page).to have_content(products[6].name)
  end
end
