# frozen_string_literal: true

class ConditionsController < ApplicationController
  before_action :set_condition, only: %i(show update destroy)
  before_action :set_experiment, only: %i(show update)
  before_action :set_breadcrumbs, only: %i(show update)

  def show
    @resource_name = "Condition: #{@condition.name}"
  end

  def update
    @resource_name = "Condition: #{@condition.name}"

    if @condition.update(condition_params)
      flash.now[:success] = 'Condition successfully updated'
    else
      flash_error_messages(@condition)
    end

    render :show
  end

  def destroy
    if @condition.destroy
      flash[:success] = 'Condition successfully deleted'
    else
      set_error_messages(@condition)
    end

    redirect_to experiment_path(@experiment)
  end

  def download_data
    redirect_to @experiment
  end

  private def set_condition
    @condition = Condition.find(params[:id])
    @experiment = @condition.experiment
  end

  private def condition_params
    params.require(:condition).permit(:name)
  end

  private def set_breadcrumbs
    @breadcrumbs = [
      OpenStruct.new(name: @experiment.name, path: experiment_path(@experiment))
    ]
  end

  private def set_experiment
    @experiment = @condition.experiment
  end
end
