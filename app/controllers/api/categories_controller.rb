# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    include SerializesProducts

    skip_before_action :authenticate_user!

    # the params that come in do not map to model attributes precisely:
    #   - param :category is a category id
    #   - param :subcategory is a subcategory's display order
    # if this action is called without those params, return products from the
    # first subcategory of the first category.
    def show
      products = Product.where(
        category_id: category_id,
        subcategory_id: subcategory.id
      )
      render json: serialized_products(products)
    end

    def index
      render json: Category.order(:id).to_json
    end

    private def subcategory
      @subcategory ||= Subcategory.find_by(
        category_id: category_id,
        display_order: params[:subcategory] || 1
      )
    end

    private def category_id
      @category_id ||= params[:category] || Category.first.id
    end
  end
end
