# frozen_string_literal: true

class ConditionsController < ApplicationController
  before_action :set_experiment
  before_action :set_breadcrumbs

  before_action :set_condition, only: %i[edit update destroy]

  def new
    @resource_name = 'Add Condition'
    @condition = ConditionPresenter.new(Condition.new)
  end

  def create
    @condition = @experiment.conditions.build
    saver = ConditionSaver.new(@condition, condition_params)
    if saver.save_condition
      flash[:success] = 'Condition successfully created'
      redirect_to edit_experiment_condition_path(@experiment, @condition)
    else
      @messages = {
        error: {
          header: 'Unable to save condition',
          messages: saver.errors
        }
      }
      @resource_name = 'Add Condition'
      render :new
    end
  end

  def edit
    @resource_name = "Condition: #{@condition.name}"
  end

  def update
    saver = ConditionSaver.new(@condition, condition_params)
    if saver.save_condition
      flash.now[:success] = 'Condition successfully updated'
    else
      @messages = {
        error: {
          header: 'Unable to save condition',
          messages: saver.errors
        }
      }
    end
    @resource_name = "Condition: #{@condition.name}"
    render :edit
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
    @condition = ConditionPresenter.new(Condition.find(params[:id]))
  end

  private def condition_params
    params.require(:condition).permit(
      :name,
      :label_type,
      :nutrition_styles,
      :label_id,
      label_attributes: %i[id image name built_in]
    )
  end

  private def set_breadcrumbs
    @breadcrumbs = [
      OpenStruct.new(name: @experiment.name, path: experiment_path(@experiment))
    ]
  end

  private def set_experiment
    @experiment = Experiment.find(params[:experiment_id])
  end
end
