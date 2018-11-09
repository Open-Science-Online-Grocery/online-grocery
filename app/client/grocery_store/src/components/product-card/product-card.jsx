import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import axios from 'axios';
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
    axios.post('/api/participant_actions', {
      sessionID: this.props.sessionID,
      conditionIdentifier: this.props.conditionIdentifier,
      actionType: 'add',
      product: this.props.product.name,
      quantity: this.state.quantity
    }).then(response => console.log(response));
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

  render() {
    return (
      <div className="product-card">
        <Link to={{ pathname: '/store/product', state: { product: this.props.product } }}>
          <img className="product-card-image" alt="product" src={this.props.product.imageSrc} />
          <div className="overlay"></div>
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
  sessionID: PropTypes.string.isRequired,
  conditionIdentifier: PropTypes.string.isRequired,
  product: PropTypes.shape({
    allergens: PropTypes.string,
    calories: PropTypes.number,
    caloriesFromFat: PropTypes.number,
    carbs: PropTypes.number,
    category: PropTypes.number,
    cholesterol: PropTypes.string,
    created_at: PropTypes.string,
    description: PropTypes.string,
    fiber: PropTypes.number,
    id: PropTypes.number,
    imageSrc: PropTypes.string,
    ingredients: PropTypes.string,
    monoFat: PropTypes.number,
    name: PropTypes.string,
    polyFat: PropTypes.number,
    potassium: PropTypes.number,
    price: PropTypes.string,
    protein: PropTypes.number,
    saturatedFat: PropTypes.number,
    servingSize: PropTypes.string,
    servings: PropTypes.string,
    size: PropTypes.string,
    sodium: PropTypes.number,
    starpoints: PropTypes.number,
    subcategory: PropTypes.number,
    sugar: PropTypes.number,
    totalFat: PropTypes.number,
    transFat: PropTypes.number,
    updated_at: PropTypes.string,
    vitamins: PropTypes.string
  }).isRequired,
  handleAddToCart: PropTypes.func.isRequired
};
