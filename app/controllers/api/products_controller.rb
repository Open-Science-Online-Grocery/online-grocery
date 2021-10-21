# frozen_string_literal: true

module Api
  class ProductsController < ApplicationController
    include Concerns::GetsCondition

    skip_power_check
    skip_before_action :authenticate_user!

    def index
      condition = condition_from_uuid
      fetcher = ProductFetcher.new(condition, params)
      paginator = Paginator.new(fetcher.fetch_products, params[:page].to_i)
      response = {
        products: paginator.records,
        page: paginator.current_page,
        total_pages: paginator.total_pages
      }

      render json: response.to_json
    end
  end
end
