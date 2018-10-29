export default class ConfirmationModal {
  constructor(message) {
    this.message = message;
    this.$modalContainer = $('[data-modal-confirm-container]');
  }

  show(approvalCallback) {
    this.$modalContainer.find('.content').html(this.message);
    this.$modalContainer.modal({ onApprove: approvalCallback });
    this.$modalContainer.modal('show');
  }
}
