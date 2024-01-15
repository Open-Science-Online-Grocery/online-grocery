# frozen_string_literal: true

module Api
  class TempCartsController < ApplicationController

    skip_power_check
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    before_action :check_condition_id, only: [:create, :find_by_session_id]
    before_action :check_api_key, only: [:create]

    def create
      @condition = Condition.find_by_uuid(params[:condition_id])

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
      @cart = TempCart.includes(cart_items: :product).find_by(session_id: params[:session_id], condition_identifier: params[:condition_identifier])
      if @cart.blank?
        render json: [message: "No cart found with condition id = #{params[:condition_identifier]} and session_id = #{params[:session_id]}." ], status: :not_found
        return
      else
        cart_attributes = @cart.attributes.merge(cart_items: @cart.cart_items.map do |ci|
          ci.attributes.merge(product: ProductSerializer.new(ci.product, @condition).serialize)
        end )
        render json: cart_attributes
      end
    end

    private

    def temp_cart_params
      params.permit(:session_id, :condition_identifier, :pop_up_message, cart_items_attributes: [:product_id, :quantity])
    end

    def check_api_key
      valid = @condition.experiment.user_id == ApiToken.find_by_uuid(params[:api_key])&.api_token_request&.user_id

      unless valid
        render json: { message: 'Please provide a valid Api Key.' }, status: :unauthorized
        return
      end
    end

    def check_condition_id
      @condition = Condition.find_by_uuid(params[:condition_identifier])
      if @condition.blank?
        render json: { message: 'Please provide a valid Condition Identifier.' }, status: :unauthorized
        return
      end
    end
  end
end
