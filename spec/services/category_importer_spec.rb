# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryImporter do
  let(:fixture_filepath) do
    Rails.root.join('spec/fixtures/files/category_importer/categories.csv')
  end

  # rubocop:disable RSpec/LetSetup
  let!(:defunct_category) { create(:category) }
  let!(:category_to_update) { create(:category, id: 1, name: 'OLD NAME') }
  # rubocop:enable RSpec/LetSetup

  before do
    allow(subject).to receive(:import_filepath) { fixture_filepath }
  end

  describe '#import' do
    it 'imports the categories as expected' do
      subject.import
      expect(Category.pluck(:name)).to eq ['Produce']
      category = Category.find(1)
      expect(category.subcategories.map { |s| [s.display_order, s.name] }).to eq(
        [
          [1, 'Fresh Fruit'],
          [2, 'Fresh Vegetables'],
          [3, 'Packaged Produce']
        ]
      )
      fruit = Subcategory.find_by(name: 'Fresh Fruit')
      expect(fruit.subsubcategories).to be_empty
      veg = Subcategory.find_by(name: 'Fresh Vegetables')
      expect(veg.subsubcategories).to be_empty
      packaged_produce = Subcategory.find_by(name: 'Packaged Produce')
      expect(packaged_produce.subsubcategories.count).to eq 1
      subsub = packaged_produce.subsubcategories.first
      expect(subsub.display_order).to eq 1
      expect(subsub.name).to eq 'Packaged Fruit'
    end
  end
end
