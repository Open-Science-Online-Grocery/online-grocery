# frozen_string_literal: true

module Api
  class CartSettingsController < ApplicationController
    skip_power_check
    skip_before_action :authenticate_user!

    def show
      condition = Condition.find_by(uuid: params[:condition_identifier])
      cart_product_data = params[:cart_products].values
        .map(&:with_indifferent_access)
      render json: CartSettingsSerializer.new(
        condition,
        cart_product_data
      ).serialize.to_json
    end
  end
end
