class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

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

  private def humanized_action
    {
      create: 'add',
      update: 'update',
      destroy: 'delete'
    }[params[:action].to_sym] || 'process'
  end
end
