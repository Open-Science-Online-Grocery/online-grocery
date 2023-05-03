# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  power :no_fallback, map: {
    %i[create] => :own_experiments
  }

  def create
    manager = PaymentsManager.new(current_user)
    if manager.create_subscription(subscription_params[:paypal_subscription_id])
      flash[:success] = 'Subscription successfully created'
    else
      flash[:error] = manager.errors.to_sentence
    end
    redirect_to experiments_path
  end

  def subscription_params
    params.permit(:paypal_subscription_id)
  end
end
