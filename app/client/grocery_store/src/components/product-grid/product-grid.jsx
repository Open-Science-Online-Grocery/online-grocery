import React from 'react';
import ProductCardContainer from '../product-card/product-card-container';
import './product-grid.scss';

export default class ProductGrid extends React.Component {
  render() {
    const productCards = this.props.products.map(product => (
      <div key={product.id} className="product-grid-item">
        <ProductCardContainer product={product} />
      </div>
    ));
    return (
      <div>{productCards}</div>
    );
  }
}
