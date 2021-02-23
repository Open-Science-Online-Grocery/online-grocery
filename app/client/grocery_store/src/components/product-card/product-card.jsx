import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import AddToCartContainer from '../add-to-cart/add-to-cart-container';
import OverlayLabel from '../overlay-label/overlay-label';
import BelowButtonLabel from '../below-button-label/below-button-label';
import GuidingStars from '../guiding-stars/guiding-stars';
import './product-card.scss';

export default class ProductCard extends React.Component {
  overlayLabels() {
    const labels = this.props.product.labels.filter(
      label => !label.labelBelowButton
    );
    return labels.map(
      label => <OverlayLabel {...label} key={label.labelImageUrl}/>
    );
  }

  belowButtonLabels() {
    const labels = this.props.product.labels.filter(
      label => label.labelBelowButton
    );
    return labels.map(
      label => <BelowButtonLabel {...label} key={label.labelImageUrl}/>
    );
  }

  addToCartButtons() {
    if (!this.props.showAddToCartButton) return null;
    return (<AddToCartContainer product={this.props.product} />);
  }

  guidingStars() {
    return (
      <div className="product-card-guiding-stars-wrapper">
        {
          this.props.showGuidingStars &&
            <GuidingStars starpoints={this.props.product.starpoints} />
        }
      </div>
    );
  }

  render() {
    return (
      <div className="product-card">
        <Link to={{ pathname: '/store/product', state: { product: this.props.product } }}>
          <div className="product-card-image-wrapper">
            <img className="product-card-image" alt="product" src={this.props.product.awsImageUrl} />
            {this.overlayLabels()}
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
        <div className="below-button-labels">
          {this.belowButtonLabels()}
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
    awsImageUrl: PropTypes.string,
    size: PropTypes.string,
    price: PropTypes.string,
    starpoints: PropTypes.number,
    labels: PropTypes.arrayOf(
      PropTypes.shape({
        labelName: PropTypes.string,
        labelImageUrl: PropTypes.string,
        labelPosition: PropTypes.string,
        labelSize: PropTypes.number,
        labelTooltip: PropTypes.string,
        labelBelowButton: PropTypes.bool
      })
    )
  }).isRequired,
  showAddToCartButton: PropTypes.bool.isRequired,
  showGuidingStars: PropTypes.bool.isRequired
};
