import nutritionStyler from '../nutrition_styler/src/index';

$(document).ready(() => {
  $('[data-nutrition-styler]').each((index, element) => {
    nutritionStyler(element);
  });
});
