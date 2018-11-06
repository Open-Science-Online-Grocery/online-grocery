export default class RadioButtonSubform {
  constructor($form) {
    this.$form = $form;
  }

  init() {
    this.setSubformClasses();
    this.$form.on('change', this.setSubformClasses.bind(this));
  }

  setSubformClasses() {
    this.$form.find('input[type="radio"]').each((index, element) => {
      const $element = $(element);
      const $subform = $element.closest('.ui.checkbox').next('.nested-fields');
      if ($element.is(':checked')) {
        $subform.removeClass('disabled');
      } else {
        $subform.addClass('disabled');
      }
    });
  }
}
