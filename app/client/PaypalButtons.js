import FlashMessage from './utils/FlashMessage';

export default class PaypalButtons {
  init() {
    paypal.Buttons({
      style: {
        shape: 'rect',
        color: 'gold',
        layout: 'horizontal',
        label: 'subscribe'
      },
      createSubscription(data, actions) {
        return actions.subscription.create({
          plan_id: 'P-0JF6342859915923DMQ4D55A'
        });
      },

      onApprove(data) {
        const form = document.createElement('form');
        form.setAttribute('method', 'POST');
        form.setAttribute('action', '/subscriptions');

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'paypal_subscription_id';
        input.value = data.subscriptionID;
        form.appendChild(input);

        const authToken = document.createElement('input');
        authToken.type = 'hidden';
        authToken.name = 'authenticity_token';
        authToken.value = document.querySelector('meta[name=csrf-token]').content;
        form.appendChild(authToken);

        document.body.appendChild(form);
        form.submit();
      },

      onError(error) {
        new FlashMessage(
          'error',
          'There was a problem creating the subscription',
          [error]
        ).showFlash();
      }
    }).render('#paypal-button-container');
  }
}
