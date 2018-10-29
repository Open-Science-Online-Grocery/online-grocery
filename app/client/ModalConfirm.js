import ConfirmationModal from './ConfirmationModal';

export default class ModalConfirm {
  constructor($modalTrigger) {
    this.$modalTrigger = $modalTrigger;
    this.modalMessage = $modalTrigger.data('modal-confirm');
    this.modal = new ConfirmationModal(this.modalMessage);
  }

  init() {
    this.setListener();
  }

  setListener() {
    this.$modalTrigger[0].addEventListener('click', this.showModal.bind(this));
  }

  // eslint-disable-next-line consistent-return
  showModal(event) {
    if (this.formInvalid()) return false;
    event.preventDefault();
    event.stopPropagation();
    const approvalCallback = () => {
      if (this.isRemoteLink()) {
        this.handleRemoteLink(event);
      } else if (this.isMethodLink()) {
        this.handleMethodLink(event);
      } else if (this.targetIsForm()) {
        this.submitForm();
      } else if (this.isCocoonRemoveLink()) {
        this.triggerCocoonRemoval();
      } else {
        this.handleRegularLink();
      }
    };
    this.modal.show(approvalCallback);
  }

  // does the trigger use rails's `remote: true` data attribute for AJAX links?
  isRemoteLink() {
    return this.$modalTrigger.data('remote');
  }

  // does the trigger have a `data-method` attribute to indicate it uses an
  // HTTP method other than GET?
  isMethodLink() {
    return this.$modalTrigger.data('method');
  }

  targetIsForm() {
    return this.form().length;
  }

  isCocoonRemoveLink() {
    // cocoon adds the class `.remove_fields` to links created via
    // `link_to_remove_association`
    return this.$modalTrigger.closest('.remove_fields').length;
  }

  handleRemoteLink(event) {
    // allow rails to handle remote links in its usual way
    $.rails.handleRemote.bind(this.$modalTrigger[0])(event);
  }

  handleMethodLink(event) {
    // allow rails to handle link with non-GET method in its usual way
    $.rails.handleMethod.bind(this.$modalTrigger[0])(event);
  }

  handleRegularLink() {
    window.location.href = this.$modalTrigger.attr('href');
  }

  submitForm() {
    // See link for reference on why form needs to be submitted
    // this way: https://github.com/rails/rails/issues/29546
    Rails.fire(this.form()[0], 'submit');
  }

  triggerCocoonRemoval() {
    // the event listener we added in this file interferes with cocoon's
    // removal behavior. here we remove the event listener we added and click
    // the link again to trigger cocoon's own behavior.
    this.$modalTrigger[0].removeEventListener(
      'click',
      this.showModal.bind(this)
    );
    this.$modalTrigger.click();
  }

  form() {
    return this.$modalTrigger.closest('[data-form-confirm]');
  }

  formInvalid() {
    if (this.form()[0]) { return !this.form().form('validate form'); }
    return false;
  }
}
