# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  layout :layout

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
end
