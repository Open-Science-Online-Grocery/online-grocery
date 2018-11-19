# frozen_string_literal: true

require 'csv'

# Use the following in the rails console to run this script:
# load './lib/scripts/produce_finder.rb'
# ProduceFinder.new.run
class ProduceFinder
  def run
    category = Category.find_by(name: 'Produce')
    products = Product.where(serving_size: nil, category_id: category)
    CSV.open(file_path, 'wb') do |csv|
      csv << headers
      products.find_each do |product|
        write_product_rows(product, csv)
      end
    end
  end

  private def write_product_rows(product, csv)
    any_rows = false
    row_base = [product.id, product.name]

    food_groups.each do |food_group|
      search_results = Hash.from_xml(
        Faraday.get(search_url(product, food_group[:id])).body
      )
      next if search_results['errors']
      any_rows = true
      items = search_results['list']['item']
      # API seems to return array only if there are multiple results
      items = [items] unless items.is_a?(Array)

      items.each do |item|
        csv << row_base + [item['name'], item['manu'], item['ndbno']]
      end
    end

    csv << row_base + Array.new(3, 'NO MATCHES') unless any_rows
  end

  private def search_url(product, food_group_id)
    formatted_name = product.name.gsub('Howes', '')
    encoded_name = URI::encode_www_form_component(formatted_name)
    "https://api.nal.usda.gov/ndb/search/?format=xml&q=#{encoded_name}"\
      "&max=500&offset=0&fg=#{food_group_id}&api_key=#{api_key}"
  end

  private def headers
    ["Howe's ID", "Howe's Name", "USDA Name", "USDA Manufacturer", "USDA ID"]
  end

  private def api_key
    @api_key ||= ENV['USDA_API_KEY']
  end

  private def file_path
    Rails.root.join('lib', 'scripts', 'produce_ids.csv')
  end

  private def food_groups
    [
      { id: "0900", name: "Fruits and Fruit Juices" },
      { id: "1600", name: "Legumes and Legume Products" },
      { id: "1200", name: "Nut and Seed Products" },
      { id: "0200", name: "Spices and Herbs" },
      { id: "1100", name: "Vegetables and Vegetable Products" },
    ]
  end
end
