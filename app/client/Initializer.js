import TableRowLinker from './TableRowLinker';
import FormValidator from './FormValidator';
import ModalConfirm from './ModalConfirm';
import FormRefresher from './FormRefresher';
import calculator from './calculator/src/index';
import nutritionStyler from './nutrition_styler/src/index';
import LoadingSpinnerButton from './LoadingSpinnerButton';

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
    this.initializeCheckboxes();
    this.initializeFormRefreshing();
    this.initializeCalculators();
    this.initializeNutritionStylers();
    this.initializeLoadingSpinnerButtons();
    this.initializeAccordions();
    this.initializeTooltipPopups();
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
    const currentTabInput = $('input[name="tab"]');
    const currentTab = currentTabInput.val();
    const $tabs = this.$scope.find('.menu .item[data-tab]');
    $tabs.each((index, element) => {
      const $tab = $(element);
      if ($tab.data('tab') === currentTab) {
        $tab.addClass('active');
        $(`.tab.segment[data-tab="${currentTab}"]`).addClass('active');
      }
      $tab.tab({ onVisible: (tab) => currentTabInput.val(tab) });
    });
  }

  initializeDropdowns() {
    const $dropdowns = this.$scope.find('.ui.dropdown:not(.react-managed)');
    $dropdowns.dropdown({ placeholder: false });
    this.$scope.find('.ui.search.dropdown').on('click', (event) => {
      if (!$(event.target).parent('.menu').length) {
        $(event.currentTarget).dropdown('show');
      }
    });
  }

  initializeCheckboxes() {
    const $checkboxes = this.$scope.find('.checkbox');
    if ($checkboxes.length) {
      $checkboxes.checkbox();
    }
  }

  initializeFormRefreshing() {
    const $refreshableForms = this.$scope.find('form[data-refresh-url]');
    $refreshableForms.each((index, element) => (
      new FormRefresher($(element)).init()
    ));
  }

  initializeCalculators() {
    this.$scope.find('[data-calculator]:not([data-delay-initialize])').each((index, element) => (
      calculator(element)
    ));
  }

  initializeNutritionStylers() {
    this.$scope.find('[data-nutrition-styler]').each((index, element) => (
      nutritionStyler(element)
    ));
  }

  initializeLoadingSpinnerButtons() {
    const $buttons = this.$scope.find(
      '.button[type="submit"], .button[data-loading-spinner]'
    );
    $buttons.each(
      (index, element) => new LoadingSpinnerButton($(element)).init()
    );
  }

  initializeAccordions() {
    const $accordions = this.$scope.find('.ui.accordion');
    $accordions.accordion();
  }

  initializeTooltipPopups() {
    this.$scope.find('[data-content]').popup({ inline: true });
  }
}
