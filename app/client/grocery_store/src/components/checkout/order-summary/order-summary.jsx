import React from 'react';
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
    const listedItems = this.props.cart.items.map((item) => {
      return (
        <div className="order-item">
          <img src={item.imageSrc} className="order-item-image"/>
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
      );
    });
    listedItems.push(
      <div className="order-item bold">Subtotal
        <span className="order-item-detail normal-height">
          <span className="order-item-price bold">
            ${parseFloat(Math.round(this.props.cart.price * 100) / 100).toFixed(2)}
          </span>
        </span>
      </div>
    );
    listedItems.push(
      <div className="order-item bold">Sales tax (7.5%)
        <span className="order-item-detail normal-height">
          <span className="order-item-price">
            ${parseFloat(Math.round(this.props.cart.price * 100) * 0.075 / 100).toFixed(2)}
          </span>
        </span>
      </div>
    );
    listedItems.push(
      <div className="order-item bold order-final-total">Total
        <span className="order-item-detail">
          ${parseFloat(Math.round(this.props.cart.price * 100) * 1.075 / 100).toFixed(2)}
        </span>
      </div>
    );
    return listedItems;
  }

  render() {
    return (
      <div className="order-summary">
        <div className="order-header-bar bold">
          Review Order
        </div>
        {this.listCartItems()}
        <button type="submit" onClick={() => this.clearCart()} className="checkout-button bold">
          Complete Order
        </button>
      </div>
    );
  }
}
