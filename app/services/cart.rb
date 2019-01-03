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

  # rubocop:disable Style/GuardClause
  def get_value(variable_token)
    variable = CartVariable.from_token(variable_token)
    if variable.in?(CartVariable.total_fields)
      return total(variable.attribute)
    elsif variable.in?(CartVariable.average_fields)
      return average(variable.attribute)
    end
    public_send(variable_token)
  end
  # rubocop:enable Style/GuardClause

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
