import React from 'react';
import PropTypes from 'prop-types';
import { Loader } from 'semantic-ui-react';
import ProductCardContainer from '../product-card/product-card-container';
import PaginationContainer from '../pagination/pagination-container';
import './product-grid.scss';

export default class ProductGrid extends React.Component {
  pageBody() {
    const { products, loaderActive } = this.props;
    if (loaderActive) return (<Loader active inline="centered" />);
    if (products.length) {
      return (
        <>
          {this.productCards()}
          <PaginationContainer />
        </>
      );
    }
    return this.noProductsMessage();
  }

  productCards() {
    return this.props.products.map(product => (
      <div key={product.id} className="product-grid-item">
        <ProductCardContainer product={product} />
      </div>
    ));
  }

  noProductsMessage() {
    if (this.props.searchType === 'term') {
      return (<p>No matching products were found</p>);
    }
    return null;
  }

  render() {
    return (
      <div className="product-grid">
        {this.pageBody()}
      </div>
    );
  }
}

ProductGrid.propTypes = {
  loaderActive: PropTypes.bool.isRequired,
  searchType: PropTypes.string.isRequired,
  products: PropTypes.arrayOf(
    PropTypes.shape({
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
    })
  ).isRequired
};
