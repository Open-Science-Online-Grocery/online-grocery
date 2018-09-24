# frozen_string_literal: true

class ExperimentsController < ApplicationController
  before_action :set_experiment, only: %i(
    new_condition
    create_condition
    show
    update
    destroy
    download_data
  )

  before_action :set_breadcrumbs, only: %i(new_condition create_condition)

  def index
    @experiments = Experiment.for_user(current_user).order('created_at desc')
  end

  def new
    @experiment = Experiment.new
    @resource_name = 'Add Experiment'
  end

  def create
    @experiment = Experiment.new(experiment_params)
    if @experiment.save
      flash[:success] = 'Experiment successfully created'
      redirect_to @experiment
    else
      set_error_messages(@experiment)
      render :new
    end
  end

  def show
    @resource_name = "Experiment: #{@experiment.name}"
    @conditions = @experiment.conditions
  end

  def update
  end

  def destroy
    if @experiment.destroy
      flash[:success] = 'Experiment successfully deleted'
    else
      set_error_messages(@experiment)
    end
    redirect_to experiments_path
  end

  def download_data
    redirect_to @experiment
  end

  def new_condition
    @condition = Condition.new
    @resource_name = 'Add Condition'
  end

  def create_condition
    @condition = @experiment.conditions.build(condition_params)
    if @condition.save
      flash[:success] = 'Condition successfully created'
      redirect_to @condition
    else
      set_error_messages(@condition)
      @resource_name = 'Add Condition'
      render :new_condition
    end
  end

  private def set_breadcrumbs
    @breadcrumbs = [
      OpenStruct.new(
        name: @experiment.name,
        path: experiment_url(@experiment)
      )
    ]
  end

  private def set_experiment
    @experiment = Experiment.find(params[:id])
  end

  private def experiment_params
    params.require(:experiment).permit(:name).merge(user: current_user)
  end

  private def condition_params
    params.require(:condition).permit(:name)
  end
end
