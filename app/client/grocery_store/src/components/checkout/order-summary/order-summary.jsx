import React from 'react';
import PropTypes from 'prop-types';
import * as routes from '../../../../../utils/routes';
import * as fromApi from '../../../../../utils/api_call';
import './order-summary.scss';

export default class OrderSummary extends React.Component {
  componentDidMount() {
    this.props.getCartSettings();
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.cart.items !== this.props.cart.items) {
      this.props.getCartSettings();
    }
  }

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

  labelStyles(item) {
    if (!item.labelImageUrl) return {};
    return {
      backgroundImage: `url(${item.labelImageUrl})`,
      backgroundPosition: item.labelPosition,
      backgroundSize: `${item.labelSize}%`
    };
  }

  listCartItems() {
    const listedItems = this.props.cart.items.map(item => (
      <div key={item.id} className="order-item">
        <div className="order-item-image-wrapper">
          <img className="order-item-image" src={item.imageSrc} />
          <div className="order-item-overlay" style={this.labelStyles(item)} />
        </div>
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
    if (!this.props.cart.showPriceTotal) return null;
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
    if (!this.props.cart.healthLabelSummary) return null;
    return (
      <div className="label-summary">
        {this.props.cart.healthLabelSummary}
      </div>
    );
  }

  customImagesSection() {
    if (this.props.cart.labelImageUrls.length > 0) {
      return (
        <div className="custom-images">
          {
            this.props.cart.labelImageUrls.map(imageUrl => (
              <img key={imageUrl} src={imageUrl} />
            ))
          }
        </div>
      );
    }
    return null;
  }

  render() {
    return (
      <div className="order-summary">
        <div className="order-header-bar bold">
          Review Order
        </div>
        {this.listCartItems()}
        {this.healthLabelsSection()}
        {this.customImagesSection()}
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
    showPriceTotal: PropTypes.bool.isRequired,
    healthLabelSummary: PropTypes.string,
    labelImageUrls: PropTypes.arrayOf(PropTypes.string),
    items: PropTypes.arrayOf(
      PropTypes.shape({
        quantity: PropTypes.number.isRequired,
        price: PropTypes.string.isRequired, // TODO: Change this to number
        name: PropTypes.string.isRequired,
        imageSrc: PropTypes.string.isRequired,
        labelImageUrl: PropTypes.string,
        labelPosition: PropTypes.string,
        labelSize: PropTypes.number
      })
    )
  }).isRequired,
  handleClearCart: PropTypes.func.isRequired,
  handleRemoveFromCart: PropTypes.func.isRequired,
  sessionId: PropTypes.string.isRequired,
  conditionIdentifier: PropTypes.string,
  getCartSettings: PropTypes.func.isRequired
};

OrderSummary.defaultProps = {
  conditionIdentifier: null
};
