// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'semantic-ui-css';
import jQuery from 'jquery';
import Initializer from '../Initializer';
import CocoonCallbacks from '../CocoonCallbacks';
import UnauthorizedRequestHandler from '../utils/UnauthorizedRequestHandler';

window.jQuery = jQuery;
window.$ = jQuery;

$(document).ready(() => {
  new Initializer($('body')).initialize();
  new CocoonCallbacks().initialize();
});

$(document).on('initialize', (_event, insertedItem) => {
  const $insertedItem = $(insertedItem);
  new Initializer($insertedItem).initialize();
  new CocoonCallbacks().initialize();
});

$(document).on('cocoon:after-insert', (_event, insertedItem) => {
  const $insertedItem = $(insertedItem);
  new Initializer($insertedItem).initialize();
});

$(document).ajaxError((e, xhr) => {
  const expiredMsg = 'Your session expired. Please sign in again to continue.';
  if (xhr.status === 401 && xhr.responseText === expiredMsg) {
    new UnauthorizedRequestHandler().showFlash();
  }
});
