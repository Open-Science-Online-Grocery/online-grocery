# frozen_string_literal: true

require 'rails_helper'

# this is needed so that the `stub_const` below doesn't overwrite Paginator
# with an empty module. see https://github.com/rspec/rspec-mocks/issues/1079
require 'paginator'

RSpec.describe 'Paginating products in grocery store', :feature do
  let(:category) { create(:category) }
  let(:subcategory) do
    create(
      :subcategory,
      name: 'fun stuff',
      category: category,
      display_order: 1
    )
  end
  let!(:products) { create_list(:product, 7, subcategory: subcategory) }
  let!(:condition) { create(:condition) }

  let!(:other_subcategory) do
    create(:subcategory, category: category, display_order: 2)
  end
  let!(:search_product_1) do
    create(:product, subcategory: other_subcategory, name: 'Fudge cookies')
  end
  let!(:search_product_2) do
    create(:product, subcategory: other_subcategory, name: 'Vanilla cookies')
  end
  let!(:search_product_3) do
    create(:product, subcategory: other_subcategory, name: 'Tiny cookies')
  end
  let!(:search_product_4) do
    create(:product, subcategory: other_subcategory, name: 'Invisible cookies')
  end

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

    # search for products
    find('.form-input').set('cookies')
    force_click('button[type="submit"]')

    expect(page).to have_content(search_product_1.name)
    expect(page).to have_content(search_product_2.name)
    expect(page).to have_content(search_product_3.name)
    expect(page).to have_no_content(search_product_4.name)

    force_click(find('.pagination a', text: '>'))

    expect(page).to have_no_content(search_product_1.name)
    expect(page).to have_no_content(search_product_2.name)
    expect(page).to have_no_content(search_product_3.name)
    expect(page).to have_content(search_product_4.name)

    actions = ParticipantAction.all
    expect(actions.count).to eq 5
    expect(actions.map(&:action_type)).to all eq 'page view'
    expect(actions.first(3).map(&:detail)).to all eq 'Subcategory: fun stuff'
    expect(actions.first(3).map(&:serial_position)).to eq [1, 2, 3]

    expect(actions.last(2).map(&:detail)).to all eq 'Search results: "cookies"'
    expect(actions.last(2).map(&:serial_position)).to eq [1, 2]
  end
end
