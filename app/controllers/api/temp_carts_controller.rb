# frozen_string_literal: true

module Api
  class TempCartsController < ApplicationController

    skip_power_check
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    def create
      @cart = TempCart.new(temp_cart_params)
      if @cart.save
        render json: @cart
      else
        render json: @cart.errors, status: :unprocessable_entity
      end
    end

    def show
      @cart = TempCart.includes(cart_items: :product).find(params[:id])
      cart_attributes = @cart.attributes.merge(cart_items: @cart.cart_items.map {|ci| ci.attributes.merge(product: ci.product)})
      render json: cart_attributes
    end

    def find_by_session_id
      @cart = TempCart.includes(cart_items: :product).find_by_session_id(params[:session_id])
      @condition = Condition.find_by_uuid(params[:condition_identifier])
      render json: nil if @cart.blank?
        cart_items: @cart.cart_items.map do |ci|
          ci.attributes.merge(
            product: ProductSerializer.new(ci.product, @condition).serialize
          )
        end
      )
      render json: cart_attributes
    end

    private

    def temp_cart_params
      params.permit(:session_id, :condition_id, cart_items_attributes: [:product_id, :quantity])
    end
  end
end
