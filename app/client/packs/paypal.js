import PaypalButtons from '../PaypalButtons';

document.addEventListener('initialize', () => {
  new PaypalButtons().init();
});
