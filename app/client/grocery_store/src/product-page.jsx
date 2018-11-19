import React from 'react';
import ProductCardExpandedContainer from './components/product-card-expanded/product-card-expanded-container';
import CartDropdownContainer from './components/cart-dropdown/cart-dropdown-container';
import './online-grocery.scss';

class ProductViewPage extends React.Component {
  render() {
    const product = this.props.location.state.product;
    return (
      <div>
        <CartDropdownContainer />
        <img className="logo-style" src={require('./images/howesgrocerybanner.png')} />
        <ProductCardExpandedContainer  {...product} />
      </div>
    );
  }
}
export default ProductViewPage
