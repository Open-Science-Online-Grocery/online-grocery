/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'babel-polyfill';
import 'semantic-ui-css';
import jQuery from 'jquery';
import Initializer from '../Initializer';

window.jQuery = jQuery;
window.$ = jQuery;

$(document).ready(() => {
  new Initializer($('body')).initialize();
});

$(document).on('initialize', (_event, insertedItem) => {
  const $insertedItem = $(insertedItem);
  new Initializer($insertedItem).initialize();
});
