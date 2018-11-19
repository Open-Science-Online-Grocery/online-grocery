export default class FormValidator {
  static getIdentifier($field) {
    if (($field.attr('type') === 'radio') || ($field.attr('type') === 'checkbox')) {
      return $field.attr('name');
    }
    // In some cases the 'name' attribute is not sufficient for setting a
    // validation, so use the 'id' if it exists.
    if ($field.attr('id') !== undefined) {
      return $field.attr('id');
    }
    return $field.attr('name');
  }

  constructor($form) {
    this.$form = $form;
  }

  setupFormValidation() {
    const hasInlineMessages = !this.$form.hasClass('group-errors');
    this.$form.form(
      {
        inline: hasInlineMessages,
        on: 'submit',
        debug: true,
        verbose: true,
        fields: this.validations(),
        // prevents semantic from calling a "submit" event when user presses
        // enter, which breaks rails remote forms.
        keyboardShortcuts: false,
        onFailure: () => {
          const firstErrorField = this.$form.find('.error.field');
          const tab = firstErrorField.closest('[data-tab]').data('tab');
          // switch to tab containing error if it's in a tab view
          if (tab) $('.tabular.menu .item').tab('change tab', tab);
          firstErrorField[0].scrollIntoView({ behavior: 'smooth' });
          return false;
        }
      }
    );
  }

  validations() {
    const validationConfig = {};
    this.$form.find('[data-validation]').each((index, element) => {
      const $field = $(element);
      const fieldName = FormValidator.getIdentifier($field);
      validationConfig[fieldName] = {
        identifier: fieldName,
        rules: this.fieldValidations($field)
      };
    });
    return validationConfig;
  }

  fieldValidations($field) {
    const validations = $field.data('validation').split('|');
    const errorMessages = ($field.data('validation-prompt') || '').split('|');
    const rules = [];
    validations.forEach((validation, index) => {
      const rule = { type: validation };
      const errorMessage = errorMessages[index];
      if (errorMessage && errorMessage.length) { rule.prompt = errorMessage; }
      rules.push(rule);
    });
    return rules;
  }
}
