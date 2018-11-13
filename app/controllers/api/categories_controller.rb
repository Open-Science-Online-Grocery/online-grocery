# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    include SerializesProducts

    skip_before_action :authenticate_user!

    def show
      products = Product.where(subcategory_id: params[:subcategory_id])
      render json: serialized_products(products)
    end
  end
end
