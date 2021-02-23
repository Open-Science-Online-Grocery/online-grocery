import React from 'react';
import PropTypes from 'prop-types';
import NutritionLabel from '../nutrition-label/nutrition-label';
import AddToCartContainer from '../add-to-cart/add-to-cart-container';
import OverlayLabel from '../overlay-label/overlay-label';
import BelowButtonLabel from '../below-button-label/below-button-label';
import GuidingStars from '../guiding-stars/guiding-stars';
import './product-details.scss';

export default class ProductDetails extends React.Component {
  guidingStars() {
    if (!this.props.showGuidingStars) return null;
    return (
      <GuidingStars starpoints={this.props.starpoints} />
    );
  }

  overlayLabels() {
    const labels = this.props.labels.filter(label => !label.labelBelowButton);
    return labels.map(
      label => <OverlayLabel {...label} key={label.labelImageUrl}/>
    );
  }

  belowButtonLabels() {
    const labels = this.props.labels.filter(label => label.labelBelowButton);
    return labels.map(
      label => <BelowButtonLabel {...label} key={label.labelImageUrl}/>
    );
  }

  render() {
    return (
      <div className="product-details">
        <div>
          <div className="product-details-name">{this.props.name}</div>
          <div className="product-details-size">{this.props.size}</div>
          <div className="product-details-price bold">
            ${parseFloat(Math.round(this.props.price * 100) / 100).toFixed(2)}
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
  showGuidingStars: PropTypes.bool.isRequired
};

ProductDetails.defaultProps = {
  starpoints: null,
  ingredients: null,
  labels: [],
  description: null,
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
  nutritionLabelCss: null
};
