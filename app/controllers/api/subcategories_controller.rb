# frozen_string_literal: true

module Api
  class SubcategoriesController < ApplicationController
    def index
      render json: Category.order(:id).to_json
    end

    def index
      render json: Subcategory.order(:category_id, :display_order).to_json
    end
  end
end
