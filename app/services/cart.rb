# frozen_string_literal: true

# represents a collection of products in a participant's cart in the
# grocery store react app.
class Cart
  # @param [Array of Hashes] - an array of hashes representing some abbreviated
  #   data about products in a cart. it looks like this:
  #   [
  #     { id: '11', quantity: '1', has_labels: ['Foo Image'] },
  #     { id: '22', quantity: '2', has_labels: ['Bar Image'] }
  #   ]
  def initialize(product_data, condition = nil)
    @product_data = product_data
    @product_data.each { |data| data[:product] = Product.find(data[:id]) }
    @condition = condition
  end

  def get_value(variable_token)
    variable = CartVariable.from_token(variable_token, @condition)
    if token_name_in?(variable, CartVariable.total_fields(@condition))
      return total(variable.attribute)
    elsif token_name_in?(
      variable, CartVariable.average_fields(@condition)
    )

      return average(variable.attribute)
    elsif token_name_in?(
      variable, CartVariable.custom_attribute_fields(@condition)
    )

      return handle_custom_attribute_fields(variable.token_name)
    end
    public_send(variable_token)
  end

  def handle_custom_attribute_fields(token_name)
    total_amount, products_with_attributes_count = calculate_product_attributes
    return 0 if products_with_attributes_count == 0

    if token_name == CartVariable
        .product_attribute_average_field(@condition).token_name

      total_amount / products_with_attributes_count
    elsif token_name == CartVariable
        .product_attribute_total_field(@condition).token_name

      total_amount
    end
  end

  def total_products
    @total_products ||= @product_data.reduce(0) do |total, item|
      total + item[:quantity].to_i
    end
  end

  def number_of_products_with_each_label
    @number_of_products_with_each_label ||= begin
      label_counts = {}

      @condition.labels.pluck(:name).each do |label|
        label_counts[label] = 0
      end

      product_labels_in_cart.compact.each do |label|
        label_counts[label] += 1
      end

      label_counts
    end
  end

  def percent_of_products_with_each_label
    @percent_of_products_with_each_label ||= number_of_products_with_each_label
      .transform_values do |count|
      total_products.zero? ? 0 : (count / total_products.to_f) * 100
    end
  end

  # This is used to allow dynamically defined label tokens to be used in
  # cart-level calculations. There will be 2 tokens added to the calculator
  # for each label defiled on the condition by the users, one for
  # `number_of_products_with_{label_name}_label` and another for
  # `percent_of_products_with_{label_name}_label`. Method missing will
  # look for these method patterns, extract, the label name, and get the
  # count or percentage for that label name, falling back on super for
  # any other undefined method calls.
  def method_missing(method_name, *args, &block)
    number_label_name = number_of_products_label_name(method_name)
    number_with_label = number_of_products_with_each_label[
      number_label_name
    ]

    return number_with_label if number_with_label.present?

    percent_label_name = percent_of_products_label_name(method_name)
    percent_with_label = percent_of_products_with_each_label[
      percent_label_name
    ]

    return percent_with_label if percent_with_label.present?

    super
  end

  def respond_to_missing?(method_name, include_private = false)
    number_of_products_label_name(method_name).present? ||
      percent_of_products_label_name(method_name).present? ||
      super
  end

  private def token_name_in?(variable, list)
    variable&.token_name.in?(list.map(&:token_name))
  end

  private def calculate_product_attributes
    products_with_attributes_count = 0
    total_amount = @product_data.pluck(:product)
      .map.with_index do |product, index|
      amount = product.custom_attribute_amount(@condition)
      if amount.present?
        quantity = @product_data[index][:quantity].to_f
        products_with_attributes_count += quantity
        amount.to_f * quantity
      end
    end.compact.reduce(:+)

    [total_amount, products_with_attributes_count]
  end

  private def number_of_products_label_name(method_name)
    match_data = method_name.match(/number_of_products_with_(\w+)_label/)
    match_data ? match_data[1] : nil
  end

  private def percent_of_products_label_name(method_name)
    match_data = method_name.match(/percent_of_products_with_(\w+)_label/)
    match_data ? match_data[1] : nil
  end

  private def product_labels_in_cart
    @product_data.flat_map do |product|
      Array.new(product[:quantity].to_i, product[:has_labels]).flatten
    end
  end

  private def average(field)
    total(field) / total_products.to_f
  end

  # NOTE: this is intentionally calculating the total *per serving* in
  # the cart, not the total in the cart as a whole. see the descriptions of
  # these fields in Equation.cart_variables
  private def total(field)
    @product_data.reduce(0) do |total, item|
      total + (item[:quantity].to_i * item[:product].public_send(field))
    end
  end
end
