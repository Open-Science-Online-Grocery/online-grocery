# frozen_string_literal: true

module Api
  class EquationValidationsController < ApplicationController
    skip_power_check

    def show
      equation = Equation.for_type(params[:type], params[:tokens])
      json = {
        data: { valid: equation.valid? },
        errors: equation.errors.full_messages.map { |error| { title: error } }
      }
      render json: json
    end
  end
end
