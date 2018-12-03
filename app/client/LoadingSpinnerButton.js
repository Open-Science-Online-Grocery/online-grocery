export default class LoadingSpinnerButton {
  constructor($button) {
    this.$button = $button;
    this.$form = $button.closest('form');
  }

  init() {
    this.$button.click(() => {
      if (!this.formIsInvalid()) {
        this.$button.addClass('loading disabled');
        $(window).one(
          'ajax:success',
          () => this.$button.removeClass('loading disabled')
        );
      }
    });
  }

  formIsInvalid() {
    if (!this.$form[0].checkValidity()) return true;
    if (!this.$form.data('form-validation')) return false;
    return !this.$form.form('validate form');
  }
}
