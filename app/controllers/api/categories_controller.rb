# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    skip_before_action :authenticate_user!

    # the params that come in do not map to model attributes precisely:
    #   - param :category is a category id
    #   - param :subcategory is a subcategory's display order
    def show
      condition = Condition.find_by(uuid: params[:conditionIdentifier])
      subcategory = Subcategory.find_by(
        category_id: params[:category],
        display_order: params[:subcategory]
      )
      products = Product.where(
        category: params[:category],
        subcategory: subcategory.id
      )
      products_hash = products.map do |product|
        ProductSerializer.new(product, condition).serialize
      end
      render json: products_hash.to_json
    end

    def index
      render json: Category.order(:id).to_json
    end
  end
end
