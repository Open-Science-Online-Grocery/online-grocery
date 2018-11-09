import React from 'react';
import ProductGridContainer from './components/product-grid/product-grid-container';
import TopNavContainer from './components/top-nav/top-nav-container';
import CartDropdownContainer from './components/cart-dropdown/cart-dropdown-container';
import './online-grocery.scss';

class HomePage extends React.Component {
  render() {
    return (
      <div>
        <CartDropdownContainer />
        <img
          className="logo-style"
          alt="Grocery store logo in banner"
          src={require('./images/howesgrocerybanner.png')}
        />
        <TopNavContainer {...this.props} />
        <ProductGridContainer />
      </div>
    );
  }
}
export default HomePage;
