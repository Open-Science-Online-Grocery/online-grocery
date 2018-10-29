import TableRowLinker from './TableRowLinker';
import FormValidator from './FormValidator';
import ModalConfirm from './ModalConfirm';
import ConditionTabs from './ConditionTabs';

export default class Initializer {
  constructor($scope) {
    this.$scope = $scope;
  }

  initialize() {
    this.initializeTableRowLinks();
    this.initializeConditionTabs();
    this.initializeModalConfirms();
    this.initializeFormValidation();
  }

  initializeTableRowLinks() {
    new TableRowLinker(this.$scope).init();
  }

  initializeConditionTabs() {
    new ConditionTabs().init();
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
}
