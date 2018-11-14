import React from 'react';
import PropTypes from 'prop-types';
import CartDropdownContainer from './components/cart-dropdown/cart-dropdown-container';
import ProductGridContainer from './components/product-grid/product-grid-container';

class SearchPage extends React.Component{
  componentWillMount() {
    this.props.updateSearchType();
  }

  render() {
    return (
      <div>
        <CartDropdownContainer />
        <img className="logo-style" src={require('./images/howesgrocerybanner.png')} />
        <div className="title"> Search Results: "{this.props.searchTerm}"</div>
        <ProductGridContainer />
      </div>
    );
  }
}

export default SearchPage;

SearchPage.propTypes = {
  searchTerm: PropTypes.string.isRequired,
  updateSearchType: PropTypes.func.isRequired
};
