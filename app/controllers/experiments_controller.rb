# frozen_string_literal: true

class ExperimentsController < ApplicationController
  before_action :set_experiment, only: %i[
    show
    edit
    update
    destroy
    download_data
  ]

  def index
    @experiments = Experiment.for_user(current_user).order(created_at: :desc)
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

  def edit
    @resource_name = "Experiment: #{@experiment.name}"
  end

  def update
    if @experiment.update(experiment_params)
      flash[:success] = 'Experiment successfully updated'
      redirect_to @experiment
    else
      set_error_messages(@experiment)
      render :edit
    end
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
    # TODO: implement
    redirect_to @experiment
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
