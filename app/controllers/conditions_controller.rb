# frozen_string_literal: true

class ConditionsController < ApplicationController
  before_action :set_experiment
  before_action :set_condition
  before_action :set_breadcrumbs
  before_action :set_tab

  def refresh_form
    manager = ConditionManager.new(@condition, adjusted_condition_params)
    manager.assign_params
    render @condition.id? ? 'edit' : 'new'
  end

  def new
    @resource_name = 'Add Condition'
  end

  def create
    manager = ConditionManager.new(@condition, adjusted_condition_params)
    if manager.update_condition
      flash[:success] = 'Condition successfully created'
      redirect_to edit_experiment_condition_path(@experiment, @condition)
    else
      @messages = {
        error: {
          header: 'Unable to save condition',
          messages: manager.errors
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
    manager = ConditionManager.new(@condition, adjusted_condition_params)
    if manager.update_condition
      flash.now[:success] = 'Condition successfully updated'
    else
      @messages = {
        error: {
          header: 'Unable to save condition',
          messages: manager.errors
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
    if params[:id].present?
      condition = Condition.find(params[:id])
    else
      condition = @experiment.conditions.build
    end
    @condition = ConditionPresenter.new(condition)
  end

  private def adjusted_condition_params
    adjusted_params = condition_params.dup
    adjusted_params
  end

  private def condition_params
    params.require(:condition).permit(
      :id,
      :name,
      :label_type,
      :label_id,
      :label_position,
      :label_size,
      :nutrition_styles,
      label_attributes: %i[id image image_cache name built_in],
      tag_csv_files_attributes: %i[id csv_file csv_file_cache]
    )
  end

  private def set_breadcrumbs
    @breadcrumbs = [
      OpenStruct.new(name: @experiment.name, path: experiment_path(@experiment))
    ]
  end

  private def set_tab
    @tab = params[:tab] || 'basic-info'
  end

  private def set_experiment
    @experiment = Experiment.find(params[:experiment_id])
  end
end
