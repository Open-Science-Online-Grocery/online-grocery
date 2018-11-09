# frozen_string_literal: true

module Api
  class ProductSearchesController < ApplicationController
    skip_before_action :authenticate_user!

    def show
      condition = Condition.find_by(uuid: params[:conditionIdentifier])
      products = Product.where(
        Product.arel_table[:name].matches("%#{params[:search]}%")
      )
      products_hash = products.map do |product|
        ProductSerializer.new(product, condition).serialize
      end
      render json: products_hash.to_json
    end
  end
end
