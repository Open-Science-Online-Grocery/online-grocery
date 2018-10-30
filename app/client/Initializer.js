import TableRowLinker from './TableRowLinker';
import FormValidator from './FormValidator';
import ModalConfirm from './ModalConfirm';

export default class Initializer {
  constructor($scope) {
    this.$scope = $scope;
  }

  initialize() {
    this.initializeTableRowLinks();
    this.initializeModalConfirms();
    this.initializeFormValidation();
    this.initializeTabs();
    this.initializeDropdowns();
  }

  initializeTableRowLinks() {
    new TableRowLinker(this.$scope).init();
  }

  initializeModalConfirms() {
    const $modalTriggers = this.$scope.find('[data-modal-confirm]');
    $modalTriggers.each(
      (index, element) => new ModalConfirm($(element)).init()
    );
  }

  initializeFormValidation() {
    const $formsWithValidation = this.$scope.find('form[data-form-validation]');
    $formsWithValidation.each((index, element) => {
      const $el = $(element);
      new FormValidator($el).setupFormValidation();
    });
  }

  initializeTabs() {
    const $tabs = this.$scope.find('.menu .item[data-tab]');
    if ($tabs.length) {
      $tabs.tab();
    }
  }

  initializeDropdowns() {
    const $dropdowns = this.$scope.find('.ui.dropdown');
    $dropdowns.dropdown({ placeholder: false });
    this.$scope.find('.ui.search.dropdown').on('click', (event) => {
      if (!$(event.target).parent('.menu').length) {
        $(event.currentTarget).dropdown('show');
      }
    });
  }
}
