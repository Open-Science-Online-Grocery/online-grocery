# frozen_string_literal: true

class ExperimentsController < ApplicationController
  power :no_fallback, as: :experiment_scope, map: {
    %i[index show edit update destroy verify_payment] => :own_experiments,
    %i[new create] => :may_create_experiments
  }

  before_action :set_experiment, only: %i[show edit update destroy]

  def index
    @api_token_request = current_user.api_token_request || ApiTokenRequest.new
    @experiments = Experiment.for_user(current_user).order(created_at: :desc)
  end

  def show
    @resource_name = "Experiment: #{@experiment.name}"
    @conditions = @experiment.conditions
  end

  def verify_payment
    manager = PaymentsManager.new(current_user)
    if manager.valid_subscription?
      js_redirect(new_experiment_url)
    else
      in_modal('shared/subscription_modal')
    end
  end

  def new
    @experiment = Experiment.new
    @resource_name = 'Add Experiment'
  end

  def edit
    @resource_name = "Experiment: #{@experiment.name}"
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
    raise(Consul::Powerless) unless experiment_scope.include?(@experiment)
  end

  private def experiment_params
    params.require(:experiment).permit(:name).merge(user: current_user)
  end

  private def condition_params
    params.require(:condition).permit(:name)
  end
end
