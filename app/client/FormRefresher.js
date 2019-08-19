// This class is meant to facilitate refreshing a form (or different portion of
// the DOM) when particular form elements are changed. This allows form logic
// (like <select> options that depend upon other form responses) to reside
// solely on the server-side.
//
// All form data will be sent to the server when a refreshed form is requested.
//
// To use, add the following data attributes and values to the form:
//   *  data-refresh-url = a url to fetch the refreshed form from
//   *  data-refresh-replace-selector = a string (CSS selector) describing the
//      part of the DOM to replace. the content returned from the server must
//      contain an element matching this selector.
//
// Add [data-refresh-form] on any form inputs that should cause the form to
// refresh when changed.
export default class FormRefresher {
  constructor($form) {
    this.$form = $form;
    this.refreshUrl = $form.data('refresh-url');
    this.replaceSelector = $form.data('refresh-replace-selector');
  }

  init() {
    this.addListener();
  }

  addListener() {
    this.$form.on('change', '[data-refresh-form]', (event) => {
      this.showLoadingSpinner();
      const formData = new FormData(this.$form[0]); // (jQuery obj)[0] is the raw HTML element
      formData.append('changed_field', event.currentTarget.name);
      $.ajax({
        url: this.refreshUrl,
        method: 'PUT',
        type: 'PUT',
        data: formData,
        processData: false,
        contentType: false,
        success: (data) => this.replaceContent(data)
      });
    });
  }

  showLoadingSpinner() {
    const $container = $(this.replaceSelector);
    $container.append(this.loaderHtml());
  }

  loaderHtml() {
    return `
      <div class="ui active inverted dimmer">
        <div class="ui loader"></div>
      </div>
    `;
  }

  replaceContent(data) {
    $(this.replaceSelector).replaceWith($(data).find(this.replaceSelector));
    $(document).trigger('initialize', $(this.replaceSelector));
  }
}
