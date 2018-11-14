# frozen_string_literal: true

# responsible for generating a csv of all product and category data with blanks
# for users to input custom categories
class ProductDataCsvManager
  require 'csv'

  def self.product_data_csv_attributes
    built_in_category_attributes.merge(custom_category_attributes)
  end

  def self.built_in_category_attributes
    {
      'Product Name' => :product_name,
      'Category' => :category,
      'Subcategory' => :subcategory
    }
  end

  def self.custom_category_attributes
    {
      'Custom Category 1' => :custom_category_1,
      'Custom Subcategory 1' => :custom_subcategory_1,
      'Custom Category 2' => :custom_category_2,
      'Custom Subcategory 2' => :custom_subcategory_2,
      'Custom Category 3' => :custom_category_3,
      'Custom Subcategory 3' => :custom_subcategory_3
    }
  end

  def self.generate_csv(product_scope = Product.all)
    CSV.generate(headers: true) do |csv|
      # headers
      csv << product_data_csv_attributes.keys

      product_scope.find_each do |product|
        csv << generate_csv_row(product)
      end
    end
  end

  def self.generate_csv_row(product)
    row = []
    category = Category.find(product.category_id)
    subcategory = Subcategory.find(product.subcategory_id)

    row << product.name
    row << category.name
    row << subcategory.name
    # empty entries for user to input custom categories
    row += Array.new(custom_category_attributes.keys.count)

    row
  end
  private_class_method :generate_csv_row
end
