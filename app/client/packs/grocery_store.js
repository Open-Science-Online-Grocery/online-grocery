import groceryStore from '../grocery_store/src/main';

$(document).ready(() => {
  $('[data-grocery-store]').each((index, element) => {
    groceryStore(element);
  });
});
