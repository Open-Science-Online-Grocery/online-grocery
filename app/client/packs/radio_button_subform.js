import RadioButtonSubform from '../RadioButtonSubform';

$(document).ready(() => {
  $('[data-radio-button-subform]').each((index, element) => {
    new RadioButtonSubform($(element)).init();
  });
});
