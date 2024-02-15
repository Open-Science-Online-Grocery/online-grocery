# frozen_string_literal: true

module Api
  class TempCartsController < ApplicationController
    skip_power_check
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    before_action :check_condition_id, only: %i[create find_by_session_id]
    before_action :check_api_key, only: [:create]

    def show
      @cart = TempCart.includes(cart_items: :product).find(params[:id])
      cart_attributes = @cart.attributes.merge(
        cart_items: @cart.cart_items.map do |ci|
          ci.attributes.merge(product: ci.product)
        end
      )
      render json: cart_attributes
    end

    def create
      @condition = Condition.find_by(uuid: params[:condition_id])

      @cart = TempCart.new(temp_cart_params)
      if @cart.save
        render json: @cart
      else
        render json: @cart.errors, status: :unprocessable_entity
      end
    end

    def find_by_session_id
      @cart = TempCart.includes(cart_items: :product).find_by(
        session_id: params[:session_id],
        condition_identifier: params[:condition_identifier]
      )
      if @cart.blank?
        render json: {
                 message: "No cart found with condition id =
                            #{params[:condition_identifier]}
                            and session_id = #{params[:session_id]}."
               },
               status: :not_found
      else
        cart_attributes = generate_cart_attributes
        render json: cart_attributes
      end
    end

    private def temp_cart_params
      params.permit(
        :session_id, :condition_identifier, :pop_up_message,
        cart_items_attributes: %i[product_id quantity]
      )
    end

    private def check_api_key
      api_token = ApiToken.find_by(uuid: params[:api_key])
      user_id = api_token&.api_token_request&.user_id
      valid = @condition.experiment.user_id == user_id

      return if valid
      render json: { message: 'Please provide a valid Api Key.' },
             status: :unauthorized
      nil
    end

    private def check_condition_id
      @condition = Condition.find_by(uuid: params[:condition_identifier])
      return if @condition.present?
      render json: { message: 'Please provide a valid Condition Identifier.' },
             status: :unauthorized
      nil
    end

    private def load_custom_fields
      custom_attributes = custom_prices = []
      if @condition.uses_custom_attributes?
        custom_attributes = load_relational_data(:custom_product_attributes)
      end
      if @condition.uses_custom_prices?
        custom_prices = load_relational_data(:custom_product_prices)
      end
      [custom_attributes, custom_prices]
    end

    private def load_relational_data(relation_attr)
      @condition.public_send(relation_attr).index_by(&:product_id) || []
    end

    private def generate_cart_attributes
      cart_items_attributes = @cart.cart_items.map do |ci|
        generate_cart_item_attributes(ci)
      end

      @cart.attributes.merge(cart_items: cart_items_attributes)
    end

    private def generate_cart_item_attributes(cart_item)
      custom_attributes, custom_prices = load_custom_fields
      product_serializer = ProductSerializer.new(
        cart_item.product, @condition,
        custom_attribute_amount: custom_attributes[cart_item.product.id]
          &.custom_attribute_amount,
        custom_price_amount: custom_prices[cart_item.product.id]&.new_price
      )

      cart_item.attributes.merge(product: product_serializer.serialize)
    end
  end
end
