# frozen_string_literal: true

# responsible for generating a csv of all product and category data with blanks
# for users to input suggested add-ons
class SuggestionsCsvManager
  def self.headers
    [
      'Product Id',
      'Product Name',
      'Add-on Id'
    ]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << headers

      Product.find_each do |product|
        csv << [product.id, product.name, '']
      end
    end
  end
end
