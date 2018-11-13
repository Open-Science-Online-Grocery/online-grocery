# frozen_string_literal: true

module Api
  class ProductsController < ApplicationController
    skip_before_action :authenticate_user!

    def index
      if params[:search_type] == 'term'
        products = Product.name_matches(params[:search_term])
      else
        products = Product.where(subcategory_id: params[:subcategory_id])
      end
      render json: serialized_products(products)
    end

    def serialized_products(products)
      condition = Condition.find_by(uuid: params[:condition_identifier])
      product_hashes = products.map do |product|
        ProductSerializer.new(product, condition).serialize
      end
      ProductSorter.new(product_hashes, condition).sorted_products.to_json
    end
  end
end
