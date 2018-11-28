import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';
import './cart-dropdown.scss';

export default class CartDropdown extends React.Component {
  constructor(props) {
    super(props);
    this.state = { dropdownOpen: false, windowHeight: 0 };
    this.openCloseDropdown = this.openCloseDropdown.bind(this);
    this.removeFromCart = this.removeFromCart.bind(this);
  }

  openCloseDropdown() {
    const currentlyOpen = this.state.dropdownOpen;
    const height = window.innerHeight;
    if (this.props.cart.items.length > 0) {
      this.setState({
        dropdownOpen: !currentlyOpen,
        windowHeight: height
      });
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

  render() {
    const cartItems = this.props.cart.items.map(item => (
      <div key={item.id} className="cart-item">
        <span>{item.name} </span>
        <span className="cart-detail">
          {
            item.quantity > 1
              && <span className="cart-quantity">{item.quantity} x </span>
          }
          <span className="cart-price">${parseFloat(Math.round(item.price * 100) / 100).toFixed(2)} </span>
        </span>
        <span onClick={() => this.removeFromCart(item)} className="cart-delete-item">X</span>
      </div>
    ));

    cartItems.unshift(
      <Link key={0} to={{ pathname: '/store/checkout' }} className="no-underline">
        <div className="cart-item cart-checkout-bar">Checkout
          <span className="cart-detail">Total: ${parseFloat(Math.round(this.props.cart.price * 100) / 100).toFixed(2)}</span>
        </div>
      </Link>
    );

    return (
      <div className="cart-button">
        <img className="cart-image" src={require('../../images/trolley-clipart-white.png')} onClick={this.openCloseDropdown} />
        <div className="cart-count">{this.props.cart.count}</div>
        {
          this.state.dropdownOpen
            && this.props.cart.items.length > 0
            && (
              <div
                style={
                  { maxHeight: this.state.windowHeight - 75 }
                }
                className="cart-dropdown"
              >
                {cartItems}
              </div>
            )
        }
      </div>
    );
  }
}

CartDropdown.propTypes = {
  cart: PropTypes.shape({
    count: PropTypes.number.isRequired,
    price: PropTypes.number.isRequired,
    items: PropTypes.arrayOf(
      PropTypes.shape({
        id: PropTypes.number.isRequired,
        quantity: PropTypes.number.isRequired,
        price: PropTypes.string.isRequired, // TODO: Change this to number
        name: PropTypes.string.isRequired
      })
    )
  }).isRequired,
  handleRemoveFromCart: PropTypes.func.isRequired,
  sessionId: PropTypes.string.isRequired,
  conditionIdentifier: PropTypes.string
};

CartDropdown.defaultProps = {
  conditionIdentifier: null
};
