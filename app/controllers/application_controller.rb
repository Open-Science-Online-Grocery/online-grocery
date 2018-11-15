# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Consul::Controller
  include Concerns::AjaxHelper

  require_power_check if: -> { !authentication_controller? }

  protect_from_forgery with: :exception
  before_action :authenticate_user!

  layout :layout

  current_power do
    Power.new(current_user)
  end

  rescue_from Consul::Powerless do
    # current_user will be nil if session has timed out
    return redirect_to(new_user_session_path) unless current_user
    message = 'You do not have access to the requested data'
    if request.format.to_sym == :json
      render(json: { error: message }, status: :unauthorized)
    elsif request.xhr?
      flash.now[:error] = message
      set_flash_via_ajax(401)
    else
      message = 'You do not have access to the requested area'
      flash[:error] = message
      redirect_back(fallback_location: root_path)
    end
  end

  private def set_error_messages(record, record_name = nil, header = nil)
    record_name ||= record.model_name.human.downcase
    header ||= "Unable to #{humanized_action} #{record_name}"
    @messages = {
      error: {
        header: header,
        messages: record.errors.full_messages
      }
    }
  end

  private def layout
    authentication_controller? ? 'authentication' : 'application'
  end

  private def authentication_controller?
    authentication_controllers = [
      Devise::SessionsController,
      Devise::RegistrationsController,
      Devise::PasswordsController,
      Devise::ConfirmationsController,
      Devise::UnlocksController
    ]
    authentication_controllers.any? do |authentication_controller|
      is_a?(authentication_controller)
    end
  end

  private def humanized_action
    {
      'create' => 'add',
      'update' => 'update',
      'destroy' => 'delete'
    }[params[:action]] || 'process'
  end

  private def authentication_controller?
    authentication_controllers = [
      Devise::SessionsController,
      Devise::RegistrationsController,
      Devise::PasswordsController,
      Devise::ConfirmationsController,
      Devise::UnlocksController
    ]
    authentication_controllers.any? do |authentication_controller|
      is_a?(authentication_controller)
    end
  end
end
