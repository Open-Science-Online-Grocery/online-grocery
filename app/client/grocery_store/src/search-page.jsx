import React from 'react';
import CartDropdownContainer from './components/cart-dropdown/cart-dropdown-container';
import ProductGridContainer from './components/product-grid/product-grid-container';

class SearchPage extends React.Component{
  render() {
    return (
      <div>
        <CartDropdownContainer />
        <img className="logo-style" src={require('./images/howesgrocerybanner.png')} />
        <div className="title"> Search Results: "{this.props.search}"</div>
        <ProductGridContainer />
      </div>
    );
  }
}

export default SearchPage;
