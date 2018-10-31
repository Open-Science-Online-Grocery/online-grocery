# frozen_string_literal: true

# See http://stackoverflow.com/a/20835382
# Override Devise's messages and translate them to flash messages.
module DeviseHelper
  def devise_error_messages!
    if resource.errors.full_messages.any?
      flash.now[:error] = {
        header: 'There was a problem with your request',
        messages: resource.errors.full_messages
      }
    end
    # Return nil so devise_error_messages! doesn't render on screen through this
    # method, and instead is only present in the flash messages
    # rubocop:disable Style/RedundantReturn
    return nil
    # rubocop:enable Style/RedundantReturn
  end
end
