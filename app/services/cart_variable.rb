class CartVariable
  def self.all
    [
      {
        token_name: 'number_of_products_with_label',
        description: 'Number of products with health label',
        attribute: :number_of_products_with_label
      },
      {
        token_name: 'percent_of_products_with_label',
        description: 'Percent of products with health label',
        attribute: :percent_of_products_with_label
      },
      {
        token_name: 'total_products',
        description: 'Total number of products',
        attribute: :total_products
      }
    ] + total_fields + average_fields
  end

  def self.total_fields
    ProductVariable.all.map do |product_variable|
      {
        token_name: "total_#{product_variable[:token_name]}",
        description: "Total #{product_variable[:description]}".capitalize,
        attribute: product_variable[:attribute]
      }
    end
  end

  def self.average_fields
    ProductVariable.all.map do |product_variable|
      {
        token_name: "avg_#{product_variable[:token_name]}",
        description: "Average #{product_variable[:description]}".capitalize,
        attribute: product_variable[:attribute]
      }
    end
  end

  def self.from_token(token_name)
    all.find { |field| field[:token_name] == token_name }
  end
end
