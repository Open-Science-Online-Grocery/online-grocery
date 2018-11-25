import React from 'react';
import PropTypes from 'prop-types';
import * as routes from '../../../../../utils/routes';
import * as fromApi from '../../../../../utils/api_call';
import './order-summary.scss';

export default class OrderSummary extends React.Component {
  removeFromCart(product) {
    this.props.handleRemoveFromCart(product);
    const actionParams = {
      sessionId: this.props.sessionId,
      conditionIdentifier: this.props.conditionIdentifier,
      actionType: 'delete',
      product: product.name,
      quantity: product.quantity
    };
    fromApi.jsonApiCall(
      routes.addParticipantAction(),
      actionParams,
      data => console.log(data),
      error => console.log(error)
    );
  }

  clearCart() {
    this.props.handleClearCart();
    this.props.cart.items.forEach((item) => {
      const actionParams = {
        sessionId: this.props.sessionId,
        conditionIdentifier: this.props.conditionIdentifier,
        actionType: 'checkout',
        product: item.name,
        quantity: item.quantity
      };
      fromApi.jsonApiCall(
        routes.addParticipantAction(),
        actionParams,
        data => console.log(data),
        error => console.log(error)
      );
    });
  }

  listCartItems() {
    const listedItems = this.props.cart.items.map(item => (
      <div className="order-item">
        <img src={item.imageSrc} className="order-item-image" />
        <div className="order-item-name">{item.name} </div>
        <span className="order-item-detail">
          {
            item.quantity > 1
              && <span className="order-item-quantity">{item.quantity} x </span>
          }
          <span className="order-item-price">
            ${parseFloat(Math.round(item.price * 100) / 100).toFixed(2)}
          </span>
        </span>
        <span onClick={() => this.removeFromCart(item)} className="order-delete-item">X</span>
      </div>
    ));
    return listedItems;
  }

  cartTotalSection() {
    if (!this.props.showPriceTotal) return null;
    return (
      <div className="cart-total-section">
        <div className="order-item bold">Subtotal
          <span className="order-item-detail normal-height">
            <span className="order-item-price bold">
              ${parseFloat(Math.round(this.props.cart.price * 100) / 100).toFixed(2)}
            </span>
          </span>
        </div>

        <div className="order-item bold">Sales tax (7.5%)
          <span className="order-item-detail normal-height">
            <span className="order-item-price">
              ${parseFloat(Math.round(this.props.cart.price * 100) * 0.075 / 100).toFixed(2)}
            </span>
          </span>
        </div>

        <div className="order-item bold order-final-total">Total
          <span className="order-item-detail">
            ${parseFloat(Math.round(this.props.cart.price * 100) * 1.075 / 100).toFixed(2)}
          </span>
        </div>
      </div>
    );
  }

  healthLabelsSection() {
    if (!this.props.showFoodCount) return null;
    return (
      <div className="order-item bold">
        Healthy Choices
        <span className="order-item-detail normal-height">
          <span className="order-item-price">{this.healthyChoicesValue()}</span>
        </span>
      </div>
    );
  }

  healthyChoicesValue() {
    if (this.props.foodCountFormat === 'ratio') {
      return (`${this.numberOfHealthyChoices()} out of ${this.props.cart.count} products`);
    }
    return (
      `${this.percentageOfHealthyChoices()}%`
    );
  }

  numberOfHealthyChoices() {
    return 3; // TODO: How do we get this number?
  }

  percentageOfHealthyChoices() {
    return (
      Math.round(
        this.numberOfHealthyChoices() / this.props.cart.count * 100
      )
    );
  }

  render() {
    return (
      <div className="order-summary">
        <div className="order-header-bar bold">
          Review Order
        </div>
        {this.listCartItems()}
        {this.healthLabelsSection()}
        {this.cartTotalSection()}
        <button type="submit" onClick={() => this.clearCart()} className="checkout-button bold">
          Complete Order
        </button>
      </div>
    );
  }
}

OrderSummary.propTypes = {
  cart: PropTypes.shape({
    count: PropTypes.number.isRequired,
    price: PropTypes.number.isRequired,
    items: PropTypes.arrayOf(
      PropTypes.shape({
        quantity: PropTypes.number.isRequired,
        price: PropTypes.string.isRequired, // TODO: Change this to number
        name: PropTypes.string.isRequired
      })
    )
  }).isRequired,
  handleClearCart: PropTypes.func.isRequired,
  handleRemoveFromCart: PropTypes.func.isRequired,
  sessionId: PropTypes.string.isRequired,
  conditionIdentifier: PropTypes.string.isRequired,
  foodCountFormat: PropTypes.string, // should be 'percent' or 'ratio'
  showFoodCount: PropTypes.bool.isRequired,
  showPriceTotal: PropTypes.bool.isRequired
};

OrderSummary.defaultProps = {
  foodCountFormat: 'percent'
};
