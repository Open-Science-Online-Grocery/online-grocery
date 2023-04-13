class PaypalButtons {
  constructor() {
    this.segment = document.querySelector('.ui.segment');
  }

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
          plan_id: 'P-41L18107F6495561SMQZDXBI'
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
      }
    }).render('#paypal-button-container');
  }
}
