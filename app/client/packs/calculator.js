import calculator from '../calculator/src/index';

$(document).ready(() => {
  $('[data-calculator]').each((index, element) => {
    calculator(element);
  });
});
