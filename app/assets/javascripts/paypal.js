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

      onApprove(data, actions) {
        console.log(data)
        // {
        //    "orderID": "3HC10659686487014",
        // => "subscriptionID": "I-HUAGNKN178UC",
        //    "facilitatorAccessToken": "A21AAIXjI3xtK5dm1PDItCrOpyAeuIXyiXtqtWzEjv1bL6yVixN2XVMJvUSiZElKZu6M0fozycQorkfLCHGxmAIcNvYyiZ8jQ",
        //    "paymentSource": "paypal"
        //  }
        alert(data.subscriptionID);
      }
    }).render('#paypal-button-container');
  }

  handleApproval(_data, actions) {
    return actions.order.capture()
      .then((details) => this.savePaymentInfo(details));
  }

  savePaymentInfo(details) {
    const form = document.createElement('form');
    form.setAttribute('method', 'POST');
    form.setAttribute('action', '/assessments/payments');

    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'details';
    input.value = JSON.stringify(details);
    form.appendChild(input);

    const authToken = document.createElement('input');
    authToken.type = 'hidden';
    authToken.name = 'authenticity_token';
    authToken.value = document.querySelector('meta[name=csrf-token]').content;
    form.appendChild(authToken);

    document.body.appendChild(form);
    form.submit();
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new PaypalButtons().init();
});
