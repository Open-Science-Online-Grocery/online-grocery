# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    # the params that come in do not map to model attributes precisely:
    #   - param :category is a category id
    #   - param :subcategory is a subcategory's display order
    def show
      subcategory = Subcategory.find_by(
        category_id: params[:category],
        display_order: params[:subcategory]
      )
      products = Product.where(
        category: params[:category],
        subcategory: subcategory.id
      )
      render json: products.to_json
    end

    def index
      render json: Category.order(:id).to_json
    end
  end
end
