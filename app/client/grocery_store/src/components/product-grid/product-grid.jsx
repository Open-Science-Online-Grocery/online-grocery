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
    return (<p>No matching products were found</p>);
  }

  render() {
    return (
      <div>
        {this.props.products.length > 0 ? this.productCards() : this.noProductsMessage()}
      </div>
    );
  }
}

ProductGrid.propTypes = {
  products: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string,
      imageSrc: PropTypes.string,
      size: PropTypes.string,
      price: PropTypes.string,
      starpoints: PropTypes.number,
      labelImageUrl: PropTypes.string,
      labelPosition: PropTypes.string,
      labelSize: PropTypes.number
    })
  ).isRequired
};
