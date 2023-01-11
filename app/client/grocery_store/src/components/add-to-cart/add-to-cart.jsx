import React from 'react';
import PropTypes from 'prop-types';
import './add-to-cart.scss';

export default class AddToCart extends React.Component {
  constructor(props) {
    super(props);
    this.state = { amount: 1, open: false, addByDollar: false };
    this.handleAddToCart = this.handleAddToCart.bind(this);
    this.subtractAmount = this.subtractAmount.bind(this);
    this.addAmount = this.addAmount.bind(this);
    this.openDropdown = this.openDropdown.bind(this);
    this.closeDropdown = this.closeDropdown.bind(this);
    this.handleOptionClick = this.handleOptionClick.bind(this);
  }

  openDropdown() {
    this.setState({ open: true });
  }

  closeDropdown() {
    this.setState({ open: false });
  }

  handleAddToCart() {
    this.props.handleAddToCart(
      this.props.product,
      this.state.amount,
      this.state.addByDollar
    );
  }

  subtractAmount() {
    this.setState(prevState => (
      { amount: prevState.amount > 1 ? prevState.amount - 1 : 1 }
    ));
  }

  addAmount() {
    this.setState(prevState => (
      { amount: prevState.amount + 1 }
    ));
  }

  handleOptionClick() {
    this.setState(prevState => (
      { addByDollar: !prevState.addByDollar }
    ));
  }

  selectedOption() {
    return this.state.addByDollar ? 'dollar amount' : 'quantity';
  }

  nonSelectedOption() {
    return this.state.addByDollar ? 'quantity' : 'dollar amount';
  }

  selectorClassName() {
    if (this.props.mayAddToCartByDollarAmount) return 'selector active';
    return 'selector';
  }

  render() {
    return (
      <div className="add-to-cart">
        <div className="label">
          {this.props.mayAddToCartByDollarAmount ? 'Add to cart by:' : 'Add to cart:'}
        </div>
        <div className="form-container">
          <div
            className={this.selectorClassName()}
            onClick={this.state.open ? this.closeDropdown : this.openDropdown}
          >
            <div className="selected">
              {this.selectedOption()}
              {this.props.mayAddToCartByDollarAmount && <span className="down-arrow">▼</span>}
            </div>
            {
              this.state.open
              && this.props.mayAddToCartByDollarAmount
              && <div className="option" onClick={this.handleOptionClick}>{this.nonSelectedOption()}</div>
            }
          </div>
          <div className="count">
            <button className="decrement" type="button" onClick={this.subtractAmount}>-</button>
            <div className="amount">
              <span>
                {this.state.addByDollar && '$'}{this.state.amount}
              </span>
            </div>
            <button className="increment" type="button" onClick={this.addAmount}>+</button>
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
    customAttribute: PropTypes.shape({
      customAttributeAmount: PropTypes.string,
      customAttributeName: PropTypes.string,
      customAttributeUnit: PropTypes.string,
      displayOnDetail: PropTypes.bool
    }),
    name: PropTypes.string,
    imageSrc: PropTypes.string,
    awsImageUrl: PropTypes.string,
    size: PropTypes.string,
    price: PropTypes.string,
    starpoints: PropTypes.number,
    labels: PropTypes.arrayOf(
      PropTypes.shape({
        labelName: PropTypes.string,
        labelImageUrl: PropTypes.string,
        labelPosition: PropTypes.string,
        labelSize: PropTypes.number
      })
    )
  }).isRequired,
  handleAddToCart: PropTypes.func.isRequired,
  mayAddToCartByDollarAmount: PropTypes.bool.isRequired
};
