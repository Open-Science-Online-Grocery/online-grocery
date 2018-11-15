# frozen_string_literal: true

class ExperimentsController < ApplicationController
  power :experiments, as: :experiment_scope, map: {
    %i[download_data index new create show edit update destroy] =>
      :own_experiments
  }

  before_action :set_experiment, only: %i[
    download_data
    show
    edit
    update
    destroy
  ]

  def download_data
    # TODO: implement
    redirect_to @experiment
  end

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

  private def set_experiment
    @experiment = Experiment.find(params[:id])
    raise Consul::Powerless unless experiment_scope.include?(@experiment)
  end

  private def experiment_params
    params.require(:experiment).permit(:name).merge(user: current_user)
  end

  private def condition_params
    params.require(:condition).permit(:name)
  end
end
