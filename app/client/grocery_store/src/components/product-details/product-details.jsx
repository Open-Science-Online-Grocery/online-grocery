import React from 'react';
import PropTypes from 'prop-types';
import NutritionLabel from '../nutrition-label/nutrition-label';
import AddToCartContainer from '../add-to-cart/add-to-cart-container';
import OverlayLabelContainer from '../overlay-label/overlay-label-container';
import BelowButtonLabelContainer from '../below-button-label/below-button-label-container';
import './product-details.scss';
import GuidingStarsContainer from '../guiding-stars/guiding-stars-container';

export default class ProductDetails extends React.Component {
  guidingStars() {
    if (!this.props.showGuidingStars) return null;
    return (
      <GuidingStarsContainer
        starpoints={this.props.starpoints}
        product={{
          id: this.props.id,
          serialPosition: this.props.serialPosition
        }}
      />
    );
  }

  overlayLabels() {
    const labels = this.props.labels.filter(label => !label.labelBelowButton);
    return labels.map(
      label => (
        <OverlayLabelContainer
          {...label}
          productId={this.props.id}
          productSerialPosition={this.props.serialPosition}
          key={label.labelImageUrl}
        />
      )
    );
  }

  belowButtonLabels() {
    const labels = this.props.labels.filter(label => label.labelBelowButton);
    return labels.map(
      label => (
        <BelowButtonLabelContainer
          {...label}
          productId={this.props.id}
          productSerialPosition={this.props.serialPosition}
          key={label.labelImageUrl}
        />
      )
    );
  }

  customAttributes() {
    if (this.props.displayCustomAttrOnDetail) {
      return (
        <div className="custom-attribute-container">
          <div className="bold">{this.props.customAttrName}:</div>
          {this.props.customAttributeAmount ? (
            <>
              <div>{this.props.customAttributeAmount}</div>
              <div>{this.props.customAttrUnit}</div>
            </>
          ) : (
            <>
              <div>N/A</div>
            </>
          )}
        </div>

      );
    }
    return <></>;
  }

  price() {
    const displayDiscount = this.props.originalPrice && this.props.displayOldPrice
    return (
      <div className="product-card-price-container">
        {displayDiscount && (
          <div className="discount-price">
            <span>
              ${parseFloat(Math.round(this.props.originalPrice * 100) / 100).toFixed(2)}
            </span>
          </div>
        )}
        ${parseFloat(Math.round(this.props.price * 100) / 100).toFixed(2)}
      </div>
    );
  }

  render() {
    return (
      <div className="product-details">
        <div>
          <div className="product-details-name">{this.props.name}</div>
          <div className="product-details-size">{this.props.size}</div>
          <div className="product-details-price bold">
            {this.price()}
          </div>
          <div className="product-details-buttons-wrapper">
            <div className="product-details-buttons">
              <AddToCartContainer product={this.props} />
              <div className="below-button-labels">
                {this.belowButtonLabels()}
              </div>
            </div>
          </div>
          <div className="product-details-image-wrapper">
            <img className="product-details-image" src={this.props.awsImageUrl} />
            {this.overlayLabels()}
          </div>
          <div className="product-details-description">{this.props.description}</div>
        </div>
        <div className="product-details-right-section">
          {this.guidingStars()}
          {this.customAttributes()}
          {
            this.props.servingSize
              && (
                <NutritionLabel
                  nutritionFacts={{
                    servingSize: this.props.servingSize,
                    servings: this.props.servings,
                    calories: this.props.calories,
                    totalFat: this.props.totalFat,
                    saturatedFat: this.props.saturatedFat,
                    transFat: this.props.transFat,
                    cholesterol: this.props.cholesterol,
                    sodium: this.props.sodium,
                    carbs: this.props.carbs,
                    fiber: this.props.fiber,
                    sugar: this.props.sugar,
                    protein: this.props.protein,
                    vitamins: this.props.vitamins
                  }}
                  css={this.props.nutritionLabelCss}
                />
              )
          }
          <span className="product-details-ingredients bold">INGREDIENTS: </span>
          <span className="product-details-ingredients">{this.props.ingredients}</span>
        </div>
      </div>
    );
  }
}

ProductDetails.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  starpoints: PropTypes.number,
  size: PropTypes.string.isRequired,
  price: PropTypes.string.isRequired,
  awsImageUrl: PropTypes.string.isRequired,
  description: PropTypes.string,
  ingredients: PropTypes.string,
  serialPosition: PropTypes.number,
  customAttributeAmount: PropTypes.string,
  originalPrice: PropTypes.string,
  displayOldPrice: PropTypes.bool,
  labels: PropTypes.arrayOf(
    PropTypes.shape({
      labelName: PropTypes.string,
      labelImageUrl: PropTypes.string,
      labelPosition: PropTypes.string,
      labelSize: PropTypes.number,
      labelTooltip: PropTypes.string,
      labelBelowButton: PropTypes.bool
    })
  ),
  servings: PropTypes.string,
  servingSize: PropTypes.string,
  calories: PropTypes.number,
  totalFat: PropTypes.number,
  saturatedFat: PropTypes.number,
  transFat: PropTypes.number,
  cholesterol: PropTypes.string,
  sodium: PropTypes.number,
  carbs: PropTypes.number,
  fiber: PropTypes.number,
  sugar: PropTypes.number,
  protein: PropTypes.number,
  vitamins: PropTypes.string,
  nutritionLabelCss: PropTypes.string,
  showGuidingStars: PropTypes.bool.isRequired,
  displayCustomAttrOnDetail: PropTypes.bool.isRequired,
  customAttrName: PropTypes.string.isRequired,
  customAttrUnit: PropTypes.string.isRequired
};

ProductDetails.defaultProps = {
  starpoints: null,
  ingredients: null,
  labels: [],
  description: null,
  customAttributeAmount: null,
  originalPrice: null,
  displayOldPrice: null,
  servings: null,
  servingSize: null,
  calories: null,
  totalFat: null,
  saturatedFat: null,
  transFat: null,
  cholesterol: null,
  sodium: null,
  carbs: null,
  fiber: null,
  sugar: null,
  protein: null,
  vitamins: null,
  nutritionLabelCss: null,
  serialPosition: null
};
