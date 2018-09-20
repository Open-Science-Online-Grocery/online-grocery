# frozen_string_literal: true

class ExperimentsController < ApplicationController
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
    @experiment = Experiment.find(params[:id])
  end

  def update
  end

  private def experiment_params
    params.require(:experiment).permit(:name).merge(user: current_user)
  end
end
