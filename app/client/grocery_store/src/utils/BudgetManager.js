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

  isOverBudget() {
    return !Number.isNaN(this.maxSpend) && this.total() > this.maxSpend;
  }

  checkoutErrorMessage() {
    let message;
    if (this.isOverBudget()) {
      message = `less than $${this.maxSpend.toFixed(2)}`;
    } else if (!Number.isNaN(this.minSpend) && this.total() < this.minSpend) {
      message = `more than $${this.minSpend.toFixed(2)}`;
    }
    if (message) {
      return `In order to check out, you must spend ${message}.`;
    }
    return null;
  }
}
