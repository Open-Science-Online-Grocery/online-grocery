# frozen_string_literal: true

class ExperimentsController < ApplicationController
  before_action :set_experiment, only: %i(show update destroy)

  def index
    @experiments = Experiment.for_user(current_user).order('created_at desc')
  end

  def new
    @experiment = Experiment.new
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

  private def set_experiment
    @experiment = Experiment.find(params[:id])
  end

  private def experiment_params
    params.require(:experiment).permit(:name).merge(user: current_user)
  end
end
