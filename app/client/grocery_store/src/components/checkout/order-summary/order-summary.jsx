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

  productLabels(item) {
    return (
      item.labels.map((label) => (
        <div
          className="order-item-overlay"
          style={this.labelStyles(label)}
          key={label.labelImageUrl}
        />
      ))
    );
  }

  labelStyles(labelAttributes) {
    if (!labelAttributes.labelImageUrl) return {};
    return {
      backgroundImage: `url(${labelAttributes.labelImageUrl})`,
      backgroundPosition: labelAttributes.labelPosition,
      backgroundSize: `${labelAttributes.labelSize}%`
    };
  }

  listCartItems() {
    const listedItems = this.props.cart.items.map((item) => (
      <div key={item.id} className="order-item">
        <div className="order-item-image-wrapper">
          <img className="order-item-image" src={item.awsImageUrl} />
          {this.productLabels(item)}
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
        <span onClick={() => this.props.handleRemoveFromCart(item)} className="order-delete-item">X</span>
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

  customAttributeSection() {
    if(!this.props.displayCustomAttrOnCheckout) {
      return null
    }

    const attributeName = this.props.customAttrName;
    const attributeUnit = this.props.customAttrUnit;
    return (
      <div className="label-summary">
        <span className="bold">Total {attributeName}:</span> {this.props.cart.customAttributeTotal} {attributeUnit}
      </div>
    );
  }

  healthLabelsSection() {
    const healthLabelSummaries = this.props.cart.healthLabelSummaries;
    if (healthLabelSummaries === null || healthLabelSummaries.length === 0) return null;
    return (
      this.props.cart.healthLabelSummaries.map((summary) => (
        <div className="label-summary" key={summary}>
          {summary}
        </div>
      ))
    );
  }

  customImagesSection() {
    if (this.props.cart.labelImageUrls.length > 0) {
      return (
        <div className="custom-images">
          {
            this.props.cart.labelImageUrls.map((imageUrl) => (
              <img key={imageUrl} src={imageUrl} />
            ))
          }
        </div>
      );
    }
    return null;
  }

  checkoutErrorMessage(errorMessage) {
    if (errorMessage) {
      return (
        <div className="error-message">
          {errorMessage}
        </div>
      );
    }
    return null;
  }

  checkoutButtonSection() {
    const {
      budgetErrorMessage,
      checkoutErrorMessage,
      checkoutProcessing,
      handleCheckout
    } = this.props;
    if (budgetErrorMessage) {
      return (
        <React.Fragment>
          {this.checkoutErrorMessage(budgetErrorMessage)}
          <button type="button" disabled className="checkout-button bold disabled">
            Complete Order
          </button>
        </React.Fragment>
      );
    } else if (checkoutProcessing) {
      return (
        <button type="button" disabled className="checkout-button bold disabled">
          Processing...
        </button>
      );
    }
    return (
      <React.Fragment>
        {this.checkoutErrorMessage(checkoutErrorMessage)}
        <button type="button" onClick={handleCheckout} className="checkout-button bold">
          Complete Order
        </button>
      </React.Fragment>
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
        {this.customAttributeSection()}
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
    customAttributeTotal: PropTypes.number.isRequired,
    healthLabelSummaries: PropTypes.arrayOf(PropTypes.string),
    labelImageUrls: PropTypes.arrayOf(PropTypes.string),
    items: PropTypes.arrayOf(
      PropTypes.shape({
        quantity: PropTypes.number.isRequired,
        price: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired,
        customAttributeTotal: PropTypes.number,
        customAttributeAmount: PropTypes.string,
        imageSrc: PropTypes.string.isRequired,
        awsImageUrl: PropTypes.string.isRequired,
        serialPosition: PropTypes.number.isRequired,
        labels: PropTypes.arrayOf(
          PropTypes.shape({
            labelName: PropTypes.string,
            labelImageUrl: PropTypes.string,
            labelPosition: PropTypes.string,
            labelSize: PropTypes.number
          })
        )
      })
    )
  }).isRequired,
  subtotal: PropTypes.string.isRequired,
  tax: PropTypes.string.isRequired,
  total: PropTypes.string.isRequired,
  budgetErrorMessage: PropTypes.string,
  checkoutErrorMessage: PropTypes.string,
  checkoutProcessing: PropTypes.bool.isRequired,
  handleCheckout: PropTypes.func.isRequired,
  handleRemoveFromCart: PropTypes.func.isRequired,
  displayCustomAttrOnCheckout: PropTypes.bool.isRequired,
  customAttrUnit: PropTypes.string,
  customAttrName: PropTypes.string,
  getCartSettings: PropTypes.func.isRequired
};

OrderSummary.defaultProps = {
  budgetErrorMessage: null,
  checkoutErrorMessage: null
};
