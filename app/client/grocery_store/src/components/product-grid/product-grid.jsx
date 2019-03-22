import React from 'react';
import PropTypes from 'prop-types';
import ProductCardContainer from '../product-card/product-card-container';
import './product-grid.scss';

export default class ProductGrid extends React.Component {
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
        {this.props.products.length > 0 ? this.productCards() : this.noProductsMessage()}
      </div>
    );
  }
}

ProductGrid.propTypes = {
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
