# frozen_string_literal: true

module Api
  class EquationValidationsController < ApplicationController
    def show
      equation = Equation.new(params[:tokens], params[:type])
      json = {
        data: { valid: equation.valid? },
        errors: equation.errors.full_messages.map { |error| { title: error} }
      }
      render json: json
    end
  end
end
