# frozen_string_literal: true

module Api
  class ProductSearchesController < ApplicationController
    def show
      products = Product.where(
        Product.arel_table[:name].matches("%#{params[:search]}%")
      )
      render json: products.to_json
    end
  end
end
