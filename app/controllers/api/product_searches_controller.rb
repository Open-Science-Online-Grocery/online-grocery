# frozen_string_literal: true

module Api
  class ProductSearchesController < ApplicationController
    include SerializesProducts

    skip_before_action :authenticate_user!

    def show
      products = Product.name_matches(params[:search])
      render json: serialized_products(products)
    end
  end
end
