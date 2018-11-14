import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';
import './product-card.scss';

export default class ProductCard extends React.Component {
  constructor(props) {
    super(props);
    this.state = { quantity: 1 };
    this.handleAddToCart = this.handleAddToCart.bind(this);
    this.subtractQuantity = this.subtractQuantity.bind(this);
    this.addQuantity = this.addQuantity.bind(this);
  }

  handleAddToCart() {
    this.props.handleAddToCart(this.props.product, this.state.quantity);
    const actionParams = {
      sessionId: this.props.sessionId,
      conditionIdentifier: this.props.conditionIdentifier,
      actionType: 'add',
      product: this.props.product.name,
      quantity: this.state.quantity
    };
    fromApi.jsonApiCall(
      routes.addParticipantAction(),
      actionParams,
      data => console.log(data),
      error => console.log(error)
    );
  }

  subtractQuantity() {
    const currentQuantity = this.state.quantity;
    if (currentQuantity > 1) {
      this.setState({ quantity: currentQuantity - 1 });
    }
  }

  addQuantity() {
    const currentQuantity = this.state.quantity;
    this.setState({ quantity: currentQuantity + 1 });
  }

  // webpack's `require` seems to have problems with interpolated strings and
  // method calls within it. using a literal string works, however.
  starImagePath() {
    const starpoints = this.props.product.starpoints;
    if (starpoints < 0) {
      return require('../../images/0howestars.png');
    }
    if (starpoints === 1 || starpoints === 2) {
      return require('../../images/1howestar.png');
    }
    if (starpoints === 3 || starpoints === 4) {
      return require('../../images/2howestars.png');
    }
    return require('../../images/3howestars.png');
  }

  labelStyles() {
    if (!this.props.product.labelImageUrl) return {};
    return {
      backgroundImage: `url(${this.props.product.labelImageUrl})`,
      backgroundPosition: this.props.product.labelPosition,
      backgroundSize: `${this.props.product.labelSize}%`
    };
  }

  render() {
    return (
      <div className="product-card">
        <Link to={{ pathname: '/store/product', state: { product: this.props.product } }}>
          <div className="product-card-image-wrapper">
            <img className="product-card-image" alt="product" src={this.props.product.imageSrc} />
            <div className="product-card-overlay" style={this.labelStyles()}></div>
          </div>
          <div className="product-card-name">{this.props.product.name}</div>
        </Link>
        <div className="product-card-size">{this.props.product.size}</div>
        <div className="product-card-price bold">
          ${parseFloat(Math.round(this.props.product.price * 100) / 100).toFixed(2)}
        </div>
        <div className="product-card-buttons">
          <img
            onClick={this.handleAddToCart}
            className="product-card-add-to-cart"
            src={require('../../images/trolley-clipart.png')}
            alt="cart icon"
          />
          <div className="product-card-quantity">
            <div className="product-card-quantity-change" onClick={this.subtractQuantity}>-</div>
            {this.state.quantity}
            <div className="product-card-quantity-change" onClick={this.addQuantity}>+</div>
          </div>
          <div className="tooltip--triangle" data-tooltip="The Guiding Stars® program evaluates the nutrient content of foods using nutrition data gleaned from the Nutrition Facts table and the ingredient list on product packaging. Click to learn more!">
            <a href="https://guidingstars.com/what-is-guiding-stars/">
              <img
                className="product-card-guiding-stars"
                src={this.starImagePath()}
                alt="Guiding Stars"
              />
            </a>
          </div>
        </div>
      </div>
    );
  }
}

ProductCard.propTypes = {
  sessionId: PropTypes.string.isRequired,
  conditionIdentifier: PropTypes.string.isRequired,
  product: PropTypes.shape({
    name: PropTypes.string,
    imageSrc: PropTypes.string,
    size: PropTypes.string,
    price: PropTypes.string,
    starpoints: PropTypes.number,
    labelImageUrl: PropTypes.string,
    labelPosition: PropTypes.string,
    labelSize: PropTypes.number
  }).isRequired,
  handleAddToCart: PropTypes.func.isRequired
};
