# frozen_string_literal: true

module Api
  class CartSettingsController < ApplicationController
    include Concerns::GetsCondition

    skip_power_check
    skip_before_action :authenticate_user!

    def show
      condition = condition_from_uuid
      cart_product_data = params.fetch(:cart_products, {}).values
        .map(&:with_indifferent_access)
      render json: CartSettingsSerializer.new(
        condition,
        cart_product_data
      ).serialize.to_json
    end
  end
end
