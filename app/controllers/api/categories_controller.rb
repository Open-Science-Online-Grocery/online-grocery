# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    include SerializesProducts

    skip_before_action :authenticate_user!

    def show
      if params[:search_type] == 'term'
        products = Product.name_matches(params[:search_term])
      else
        products = Product.where(subcategory_id: params[:subcategory_id])
      end
      render json: serialized_products(products)
    end
  end
end
