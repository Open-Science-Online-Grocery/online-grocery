import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import AddToCartContainer from '../add-to-cart/add-to-cart-container';
import './product-card.scss';

export default class ProductCard extends React.Component {
  // webpack's `require` seems to have problems with interpolated strings and
  // method calls within it. using a literal string works, however.
  starImagePath() {
    const starpoints = this.props.product.starpoints;
    if (starpoints < 0) {
      return require('../../images/0howestars.png');
    }
    if (starpoints === 1 || starpoints === 2) {
      return require('../../images/1howestar.png');
    }
    if (starpoints === 3 || starpoints === 4) {
      return require('../../images/2howestars.png');
    }
    return require('../../images/3howestars.png');
  }

  productLabels() {
    return (
      this.props.product.labels.map(label => (
        <div
          className="product-card-overlay"
          style={this.labelStyles(label)}
          key={label.labelImageUrl}
        />
      ))
    );
  }

  labelStyles(labelAttributes) {
    if (!labelAttributes.labelImageUrl) return {};
    return {
      backgroundImage: `url(${labelAttributes.labelImageUrl})`,
      backgroundPosition: labelAttributes.labelPosition,
      backgroundSize: `${labelAttributes.labelSize}%`
    };
  }

  addToCartButtons() {
    if (!this.props.showAddToCartButton) return null;
    return (<AddToCartContainer product={this.props.product} />);
  }

  guidingStars() {
    if (!this.props.showGuidingStars) return <div className="product-card-guiding-stars-wrapper" />;
    return (
      <div className="tooltip--triangle product-card-guiding-stars-wrapper" data-tooltip="The Guiding Stars® program evaluates the nutrient content of foods using nutrition data gleaned from the Nutrition Facts table and the ingredient list on product packaging. Click to learn more!">
        <a href="https://guidingstars.com/what-is-guiding-stars/">
          <img
            className="product-card-guiding-stars"
            src={this.starImagePath()}
            alt="Guiding Stars"
          />
        </a>
      </div>
    );
  }

  render() {
    return (
      <div className="product-card">
        <Link to={{ pathname: '/store/product', state: { product: this.props.product } }}>
          <div className="product-card-image-wrapper">
            <img className="product-card-image" alt="product" src={this.props.product.imageSrc} />
            {this.productLabels()}
          </div>
          <div className="product-card-name">{this.props.product.name}</div>
        </Link>
        <div className="product-card-size">{this.props.product.size}</div>
        <div className="product-card-price bold">
          ${parseFloat(Math.round(this.props.product.price * 100) / 100).toFixed(2)}
        </div>
        <div className="product-card-buttons">
          {this.guidingStars()}
          {this.addToCartButtons()}
        </div>
      </div>
    );
  }
}

ProductCard.propTypes = {
  product: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
    imageSrc: PropTypes.string,
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
  showAddToCartButton: PropTypes.bool.isRequired,
  showGuidingStars: PropTypes.bool.isRequired
};
