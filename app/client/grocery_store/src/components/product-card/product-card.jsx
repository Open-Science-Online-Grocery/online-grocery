import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import AddToCartContainer from '../add-to-cart/add-to-cart-container';
import OverlayLabelContainer from '../overlay-label/overlay-label-container';
import BelowButtonLabel from '../below-button-label/below-button-label';
import './product-card.scss';
import GuidingStarsContainer from '../guiding-stars/guiding-stars-container';

export default class ProductCard extends React.Component {
  overlayLabels() {
    const labels = this.props.product.labels.filter(
      label => !label.labelBelowButton
    );
    return labels.map(
      label => (
        <OverlayLabelContainer
          {...label}
          productId={this.props.product.id}
          productSerialPosition={this.props.product.serialPosition}
          key={label.labelImageUrl}
        />
      )
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
          this.props.showGuidingStars && (
            <GuidingStarsContainer
              starpoints={this.props.product.starpoints}
              product={{
                id: this.props.product.id,
                serialPosition: this.props.product.serialPosition
              }}
            />
          )
        }
      </div>
    );
  }

  price() {
    const displayDiscount = this.props.product.originalPrice && this.props.displayOldPrice;
    return (
      <div className="product-card-price-container">
        {displayDiscount && (
          <div className="discount-price">
            <span>
              ${parseFloat(Math.round(this.props.product.originalPrice * 100) / 100).toFixed(2)}
            </span>
          </div>
        )}
        ${parseFloat(Math.round(this.props.product.price * 100) / 100).toFixed(2)}
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
        <div>
          <div className="product-card-size">{this.props.product.size}</div>
          <div className="product-card-price bold">
            {this.price()}
          </div>
          <div className="product-card-buttons">
            {this.guidingStars()}
            {this.addToCartButtons()}
          </div>
          <div className="below-button-labels">
            {this.belowButtonLabels()}
          </div>
        </div>
      </div>
    );
  }
}

ProductCard.propTypes = {
  product: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
    customAttributeAmount: PropTypes.string,
    serialPosition: PropTypes.number,
    imageSrc: PropTypes.string,
    awsImageUrl: PropTypes.string,
    size: PropTypes.string,
    price: PropTypes.string,
    originalPrice: PropTypes.string,
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
