import React from 'react';
import PropTypes from 'prop-types';
import './order-summary.scss';

// NOTE: if the appearance of this component changes, be sure to also update the
// images used in app/views/conditions/_cart_summary_tab.html.erb
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
    this.props.logParticipantAction('delete', product.id, product.quantity);
  }

  clearCart() {
    this.props.handleClearCart();
    this.props.cart.items.forEach((item) => {
      this.props.logParticipantAction('checkout', item.id, item.quantity);
    });
    this.props.onSubmit();
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
            ${parseFloat(item.price).toFixed(2)}
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
              ${this.props.subtotal}
            </span>
          </span>
        </div>

        <div className="order-item bold">Sales tax (7.5%)
          <span className="order-item-detail normal-height">
            <span className="order-item-price">
              ${this.props.tax}
            </span>
          </span>
        </div>

        <div className="order-item bold order-final-total">Total
          <span className="order-item-detail">
            ${this.props.total}
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

  checkoutErrorMessage() {
    if (this.props.errorMessage) {
      return (
        <div className="error-message">
          {this.props.errorMessage}
        </div>
      );
    }
    return null;
  }

  checkoutButtonSection() {
    if (this.props.errorMessage) {
      return (
        <React.Fragment>
          {this.checkoutErrorMessage()}
          <button type="submit" disabled className="checkout-button bold disabled">
            Complete Order
          </button>
        </React.Fragment>
      );
    }
    return (
      <button type="submit" onClick={() => this.clearCart()} className="checkout-button bold">
        Complete Order
      </button>
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
        {this.customImagesSection()}
        {this.cartTotalSection()}
        {this.checkoutButtonSection()}
      </div>
    );
  }
}

OrderSummary.propTypes = {
  cart: PropTypes.shape({
    count: PropTypes.number.isRequired,
    showPriceTotal: PropTypes.bool.isRequired,
    healthLabelSummary: PropTypes.string,
    labelImageUrls: PropTypes.arrayOf(PropTypes.string),
    items: PropTypes.arrayOf(
      PropTypes.shape({
        quantity: PropTypes.number.isRequired,
        price: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired,
        imageSrc: PropTypes.string.isRequired,
        labelImageUrl: PropTypes.string,
        labelPosition: PropTypes.string,
        labelSize: PropTypes.number
      })
    )
  }).isRequired,
  subtotal: PropTypes.string.isRequired,
  tax: PropTypes.string.isRequired,
  total: PropTypes.string.isRequired,
  errorMessage: PropTypes.string,
  handleClearCart: PropTypes.func.isRequired,
  handleRemoveFromCart: PropTypes.func.isRequired,
  getCartSettings: PropTypes.func.isRequired,
  logParticipantAction: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired
};

OrderSummary.defaultProps = {
  errorMessage: null
};
