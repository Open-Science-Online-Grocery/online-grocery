export default class ModalConfirm {
  constructor($modalTrigger) {
    this.$modalTrigger = $modalTrigger;
    this.modalMessage = $modalTrigger.data('modal-confirm');
    this.$modalContainer = $('[data-modal-confirm-container]');
  }

  init() {
    this.setListener();
  }

  setListener() {
    if (this.$modalTrigger.data('modal-confirm-checkbox-event')) {
      const eventType = this.$modalTrigger.data('modal-confirm-checkbox-event') || 'beforeChecked';
      this.$modalTrigger.checkbox('setting', eventType, () => this.showCheckboxModal());
    } else {
      const eventType = this.$modalTrigger.data('modal-confirm-event') || 'click';
      this.$modalTrigger.on(eventType, event => this.showLinkModal(event));
    }
  }

  showModal(approveFunc, denyFunc) {
    this.setModalMessage();
    this.$modalContainer.modal({
      onApprove: () => {
        if (approveFunc && typeof approveFunc === 'function') {
          approveFunc();
        } else {
          this.$modalContainer.modal('hide');
        }
      },
      onDeny: () => {
        if (denyFunc && typeof denyFunc === 'function') {
          denyFunc();
        } else {
          this.$modalContainer.modal('hide');
        }
      }
    });
    this.$modalContainer.modal('show');
  }

  showLinkModal(event) {
    event.preventDefault();
    event.stopPropagation();
    this.showModal(() => {
      const $target = $(event.currentTarget);
      if (!$target.data('nested-delete-link') && $target.data('remote') === undefined && $target.data('method') === undefined && $target.attr('href')) {
        window.location.href = $target.attr('href');
      } else if ($target.data('remote')) {
        $.rails.handleRemote.call(event.currentTarget, event);
      } else {
        $.rails.handleMethod.bind(event.currentTarget)(event);
      }
    });
  }

  showCheckboxModal() {
    this.showModal(() => {
      this.$modalTrigger.checkbox('set checked');
    }, () => {
      this.$modalTrigger.checkbox('set unchecked');
      this.$modalContainer.modal('hide');
    });
    // returning false prevents change, making state entirely up to the modal
    return false;
  }

  showDetachedModal(text, approveFunc, denyFunc) {
    this.setModalMessage(text);
    this.showModal(approveFunc, denyFunc);
  }

  setModalMessage(text) {
    if (text) {
      this.modalMessage = text;
    }
    this.$modalContainer.find('.content').html(this.modalMessage);
  }
}
