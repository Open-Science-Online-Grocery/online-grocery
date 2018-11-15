# frozen_string_literal: true

module Api
  class ProductsController < ApplicationController
    skip_before_action :authenticate_user!

    def index
      fetcher = ProductFetcher.new(params)
      render json: fetcher.fetch_products.to_json
    end
  end
end
