class CartVariable
  def self.all
    [
      {
        token_name: :number_of_products_with_label,
        description: 'Number of products with health label',
        attribute: ''
      },
      {
        token_name: :percent_of_products_with_label,
        description: 'Percent of products with health label',
        attribute: ''
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
end
