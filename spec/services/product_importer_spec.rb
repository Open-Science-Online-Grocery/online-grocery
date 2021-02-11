# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductImporter do
  # rubocop:disable RSpec/LetSetup
  let(:fixture_filepath) do
    Rails.root.join('spec/fixtures/files/product_importer/products.csv')
  end
  let!(:category) { Category.find_or_create_by!(id: 7, name: 'Snacks') }
  let!(:subcategory_1) do
    category.subcategories.find_or_create_by!(
      display_order: 1, name: 'Crackers'
    )
  end
  let!(:subcategory_2) do
    category.subcategories.find_or_create_by!(
      display_order: 4, name: 'Chips, Pretzels & Rice Cakes'
    )
  end
  let!(:subsubcategory) do
    subcategory_2.subsubcategories.find_or_create_by!(
      display_order: 1, name: 'Rice Cakes'
    )
  end
  let(:saltine_attrs) do
    {
      'id' => 2,
      'name' => 'Premium Crackers, Saltine, Original',
      'size' => '1 lb (453 g)',
      'description' => nil,
      'image_src' => 'http://www.publix.com/images/products/300000/300550-600x600-A.jpg',
      'serving_size' => '5 Cracker(s) (16g)',
      'serving_size_grams' => 100.0,
      'servings' => '28',
      'calories_from_fat' => 15,
      'calories' => 70,
      'caloric_density' => 11.1,
      'total_fat' => 2,
      'saturated_fat' => 0,
      'trans_fat' => 0,
      'poly_fat' => 1,
      'mono_fat' => 0,
      'cholesterol' => 0.0,
      'sodium' => 135,
      'potassium' => nil,
      'carbs' => 12,
      'fiber' => 0,
      'sugar' => 0,
      'protein' => 1,
      'vitamins' => '0% Vitamin A 0% Vitamin C 0% Calcium 4% Iron',
      'ingredients' => 'Unbleached Enriched Flour (Wheat Flour, Niacin, Reduced Iron, Thiamine Mononitrate {Vitamin B1}, Riboflavin {Vitamin B2}, Folic Acid), Vegetable Oil (Soybean And/Or Canola And/Or Palm And/Or Partially Hydrogenated Cottonseed Oil), Sea Salt, Salt, Malted Barley Flour, Baking Soda, Yeast.',
      'allergens' => 'Contains: Wheat.',
      'price' => 12.99,
      'category_id' => 7,
      'starpoints' => 3,
      'aws_image_url' => 'https://com-howes-grocery-product-images.s3.amazonaws.com/2'
    }
  end
  let(:rice_cake_attrs) do
    {
      'id' => 92,
      'name' => 'Good Thins Rice Snacks, Simply Salt',
      'size' => '3.5 oz (100 g)',
      'description' => "The rice one. The Goods: no artificial colors; no artificial flavors; no cholesterol; no partially hydrogenated oils; no high fructose corn syrup. Per 18 Pieces: 130 calories; 0 g sat fat (0% DV); 85 mg sodium (4% DV); 0 g sugars. We're gluten free. Open for good thins! The wonderful Simply Salt so confident with nothing to hide. Taste this crisp baked sensation in its delicious simplicity. SmartLabel. Please recycle carton. This package is sold by weight, not by volume. If it does not appear full when opened, it is because contents have settled during shipping and handling. Questions or comments? Call weekdays: 1-800-622-4726. Please have package available.Show Lessll when opened, it is because contents have settled during shipping and handling. Questions or comments? Call weekdays: 1-800-622-4726. Please have package available.",
      'image_src' => 'http://www.publix.com/images/products/310000/314740-600x600-A.jpg',
      'serving_size' => '18 Piece(s) (31g)',
      'serving_size_grams' => 200.0,
      'servings' => '3',
      'calories_from_fat' => 15,
      'calories' => 130,
      'caloric_density' => 22.2,
      'total_fat' => 2,
      'saturated_fat' => 0,
      'trans_fat' => 0,
      'poly_fat' => nil,
      'mono_fat' => 1,
      'cholesterol' => 0.0,
      'sodium' => 85,
      'potassium' => 30,
      'carbs' => 26,
      'fiber' => 0,
      'sugar' => 0,
      'protein' => 2,
      'vitamins' => '0% Vitamin A 0% Vitamin C 0% Calcium 0% Iron',
      'ingredients' => 'White Rice Flour, High Oleic Safflower Oil, Salt.',
      'allergens' => 'Manufactured On Equipment That Processes Soy, Sesame Seed, Tree Nuts.',
      'price' => 2.56,
      'category_id' => 7,
      'starpoints' => 6,
      'aws_image_url' => 'https://com-howes-grocery-product-images.s3.amazonaws.com/92'
    }
  end
  let!(:defunct_product) { create(:product) }
  let!(:product_to_update) { create(:product, id: 92, name: 'OLD NAME') }
  # rubocop:enable RSpec/LetSetup

  before do
    allow(subject).to receive(:import_filepath) { fixture_filepath }
  end

  describe '#import' do
    it 'imports the products as expected' do
      subject.import
      saltines = Product.find(2)
      expect(
        saltines.attributes.except(
          'created_at', 'updated_at', 'subcategory_id', 'subsubcategory_id'
        )
      ).to eq saltine_attrs
      expect(saltines.category.name).to eq 'Snacks'
      expect(saltines.subcategory.name).to eq 'Crackers'
      expect(saltines.subsubcategory).to be_nil

      rice_cakes = Product.find(92)
      expect(
        rice_cakes.attributes.except(
          'created_at', 'updated_at', 'subcategory_id', 'subsubcategory_id'
        )
      ).to eq rice_cake_attrs
      expect(rice_cakes.category.name).to eq 'Snacks'
      expect(rice_cakes.subcategory.name).to eq 'Chips, Pretzels & Rice Cakes'
      expect(rice_cakes.subsubcategory.name).to eq 'Rice Cakes'
      expect(Product.find_by(id: defunct_product.id)).to be_nil
    end
  end
end
