# frozen_string_literal: true

# represents a collection of products in a participant's cart in the
# grocery store react app.
class Cart
  # @param [Array of Hashes] - an array of hashes representing some abbreviated
  #   data about products in a cart. it looks like this:
  #   [
  #     { id: '11', quantity: '1', has_label: 'true' },
  #     { id: '22', quantity: '2', has_label: 'false' }
  #   ]
  def initialize(product_data)
    @product_data = product_data
    @product_data.each { |data| data[:product] = Product.find(data[:id]) }
  end

  def total_products
    @total_products ||= @product_data.reduce(0) do |total, item|
      total + item[:quantity].to_i
    end
  end

  def number_of_products_with_label
    @number_of_products_with_label ||= @product_data.reduce(0) do |total, item|
      item[:has_label] == 'true' ? total + item[:quantity].to_i : total
    end
  end

  def percent_of_products_with_label
    @percent_of_products_with_label ||= begin
      return 0 if total_products.zero?
      (number_of_products_with_label / total_products.to_f) * 100
    end
  end

  def avg_calories_from_fat
    average(:calories_from_fat)
  end

  def avg_calories
    average(:calories)
  end

  def avg_total_fat
    average(:total_fat)
  end

  def avg_saturated_fat
    average(:saturated_fat)
  end

  def avg_trans_fat
    average(:trans_fat)
  end

  def avg_cholesterol
    average(:cholesterol)
  end

  def avg_sodium
    average(:sodium)
  end

  def avg_carbs
    average(:carbs)
  end

  def avg_fiber
    average(:fiber)
  end

  def avg_sugar
    average(:sugar)
  end

  def avg_protein
    average(:protein)
  end

  def avg_price
    average(:price)
  end

  def avg_starpoints
    average(:starpoints)
  end

  def total_calories_from_fat
    total(:calories_from_fat)
  end

  def total_calories
    total(:calories)
  end

  def total_total_fat
    total(:total_fat)
  end

  def total_saturated_fat
    total(:saturated_fat)
  end

  def total_trans_fat
    total(:trans_fat)
  end

  def total_cholesterol
    total(:cholesterol)
  end

  def total_sodium
    total(:sodium)
  end

  def total_carbs
    total(:carbs)
  end

  def total_fiber
    total(:fiber)
  end

  def total_sugar
    total(:sugar)
  end

  def total_protein
    total(:protein)
  end

  def total_price
    total(:price)
  end

  def total_starpoints
    total(:starpoints)
  end

  private def average(field)
    total(field) / total_products.to_f
  end

  # note that this is intentionally calculating the total *per serving* in
  # the cart, not the total in the cart as a whole. see the descriptions of
  # these fields in Equation.cart_variables
  private def total(field)
    @product_data.reduce(0) do |total, item|
      total + (item[:quantity].to_i * item[:product].public_send(field))
    end
  end
end
