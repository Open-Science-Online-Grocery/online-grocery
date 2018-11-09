import FlashMessage from './FlashMessage';

export default class UnauthorizedRequestHandler {
  showFlash() {
    new FlashMessage('error', this.signInMessage(), []).showFlash();
    $('.active.dimmer').remove();
    $('html, body').animate({ scrollTop: $('[data-flash]').offset().top }, 200);
  }

  // we give the user a link to refresh the page here. when they click and
  // refresh the page, Devise steps in and takes them to the sign-in page
  // instead. after sign-in, they will be redirected back to the page they
  // we were on when they timed out.
  signInMessage() {
    return `
      Your session has timed out. Please
      <a href="${window.location.toString()}"> click here</a>
      to sign in again.
    `;
  }
}
