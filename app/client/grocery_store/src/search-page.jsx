import React from 'react';
import PropTypes from 'prop-types';
import CartDropdownContainer from './components/cart-dropdown/cart-dropdown-container';
import ProductGridContainer from './components/product-grid/product-grid-container';
import SortLinksContainer from './components/sort-links/sort-links-container';
import './search-page.scss';

class SearchPage extends React.Component {
  componentDidMount() {
    this.props.updateSearchType();
  }

  render() {
    return (
      <div className="search-page">
        <CartDropdownContainer />
        <img className="logo-style" src={require('./images/howesgrocerybanner.png')} />
        <div className="search-container">
          <SortLinksContainer />
        </div>
        <span onClick={this.props.history.goBack} className="navigate-back">
          {"<"} Back to Browsing
        </span>
        <div className="title"> Search Results: &quot;{this.props.searchTerm}&quot;</div>
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
