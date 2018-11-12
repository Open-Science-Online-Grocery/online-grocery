module SerializesProducts
  def serialized_products(products)
    condition = Condition.find_by(uuid: params[:condition_identifier])
    product_hashes = products.map do |product|
      ProductSerializer.new(product, condition).serialize
    end
    ProductSorter.new(product_hashes, condition).sorted_products.to_json
  end
end
