# frozen_string_literal: true

module Support
  module AjaxHelper
    private def in_cancelable_modal(partial_name, modal_selector = nil)
      in_modal(partial_name, cancelable: true, modal_selector: modal_selector)
    end

    # A "cancelable" modal has some UI element (like an "X" or a cancel button)
    # that will close the modal without taking any other action.
    private def in_modal(partial_name, cancelable: false, modal_selector: nil)
      render(
        '/shared/show_in_modal',
        locals: {
          partial_name: partial_name,
          cancelable: cancelable,
          modal_selector: modal_selector
        }
      )
    end

    private def set_flash_via_ajax(
      status = 200, flash_selector = '[data-flash]'
    )
      @flash_selector = flash_selector
      render 'shared/set_flash', status: status
    end

    private def js_redirect(path)
      render 'shared/js_redirect', locals: { redirect_path: path }
    end
  end
end
