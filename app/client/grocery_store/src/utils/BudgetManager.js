export default class BudgetManager {
  constructor(cartPrice, maxSpend, minSpend) {
    this.cartPrice = cartPrice;
    this.maxSpend = parseFloat(maxSpend);
    this.minSpend = parseFloat(minSpend);
  }

  subtotal() {
    return this.cartPrice.toFixed(2);
  }

  tax() {
    return (this.cartPrice * 0.075).toFixed(2);
  }

  total() {
    return (this.cartPrice * 1.075).toFixed(2);
  }

  overMaxSpend() {
    return !Number.isNaN(this.maxSpend) && this.subtotal() > this.maxSpend;
  }

  underMinSpend() {
    return !Number.isNaN(this.minSpend) && this.subtotal() < this.minSpend;
  }

  checkoutErrorMessage() {
    let message;
    if (this.overMaxSpend()) {
      message = `less than $${this.maxSpend.toFixed(2)}`;
    } else if (this.underMinSpend()) {
      message = `more than $${this.minSpend.toFixed(2)}`;
    }
    if (message) {
      return `In order to check out, you must spend ${message}.`;
    }
    return null;
  }
}
