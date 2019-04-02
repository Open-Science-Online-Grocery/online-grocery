export default class BudgetManager {
  constructor(cartPrice, maxSpend, minSpend) {
    this.cartPrice = cartPrice;
    this.cartSNAP = cartPrice; //need to change this 
    this.maxSpend = parseFloat(maxSpend);
    this.minSpend = parseFloat(minSpend);
    this.maxSNAP = 50;
  }

  subtotal() {
    return this.cartPrice.toFixed(2);
  }

  SNAPsubtotal() {
    return this.cartSNAP.toFixed(2);
  }

  tax() {
    return (this.cartPrice * 0.075).toFixed(2);
  }

  total() {
    return (this.cartPrice * 1.075).toFixed(2);
  }

  overMaxSNAP() {
    return !Number.isNaN(this.maxSNAP) && this.SNAPsubtotal() > this.maxSNAP;
  }

  overMaxSpend() {
    return !Number.isNaN(this.maxSpend) && this.subtotal() > this.maxSpend;
  }

  underMinSpend() {
    return !Number.isNaN(this.minSpend) && this.subtotal() < this.minSpend;
  }

  checkoutErrorMessage() {
    let message;
    /*
    if (this.overMaxSNAP()) {
      message = `less than $${this.maxSNAP.toFixed(2)} of SNAP dollars`;
    }
    */
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
