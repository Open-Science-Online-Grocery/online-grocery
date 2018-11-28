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

  private def average(field)
    sum = @product_data.reduce(0) do |total, item|
      total + (item[:quantity].to_i * item[:product].public_send(field))
    end
    sum / total_products.to_f
  end
end
