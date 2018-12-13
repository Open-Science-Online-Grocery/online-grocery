import React from 'react';
import PropTypes from 'prop-types';
import './add-to-cart.scss';

export default class AddToCart extends React.Component {
  constructor(props) {
    super(props);
    this.state = { quantity: 1 };
    this.handleAddToCart = this.handleAddToCart.bind(this);
    this.subtractQuantity = this.subtractQuantity.bind(this);
    this.addQuantity = this.addQuantity.bind(this);
  }

  handleAddToCart() {
    this.props.handleAddToCart(this.props.product, this.state.quantity);
    this.props.logParticipantAction('add', this.props.product.id, this.state.quantity);
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

  render() {
    return (
      <div className="add-to-cart">
        <div className="label">Add to cart by:</div>
        <div className="form-container">
          <div className="selector">
            <div className="selected">quantity <span className="down-arrow">▼</span></div>
          </div>
          <div className="count">
            <button className="decrement" type="button" onClick={this.subtractQuantity}>-</button>
            <span className="quantity">{this.state.quantity}</span>
            <button className="increment" type="button" onClick={this.addQuantity}>+</button>
          </div>
          <div onClick={this.handleAddToCart} className="submit">✓</div>
        </div>
      </div>
    );
  }
}

AddToCart.propTypes = {
  product: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
    imageSrc: PropTypes.string,
    size: PropTypes.string,
    price: PropTypes.string,
    starpoints: PropTypes.number,
    labelImageUrl: PropTypes.string,
    labelPosition: PropTypes.string,
    labelSize: PropTypes.number
  }).isRequired,
  handleAddToCart: PropTypes.func.isRequired,
  logParticipantAction: PropTypes.func.isRequired
};
