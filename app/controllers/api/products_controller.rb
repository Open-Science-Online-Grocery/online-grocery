# frozen_string_literal: true

module Api
  class ProductsController < ApplicationController
    include Concerns::GetsCondition

    skip_power_check
    skip_before_action :authenticate_user!

    def index
      condition = condition_from_uuid
      fetcher = ProductFetcher.new(condition, params)
      render json: fetcher.fetch_products.to_json
    end
  end
end
