# frozen_string_literal: true

module Api
  class SubcategoriesController < ApplicationController
    skip_before_action :authenticate_user!

    def index
      render json: Subcategory.order(:category_id, :display_order).to_json
    end
  end
end
