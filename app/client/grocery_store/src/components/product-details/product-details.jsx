import React from 'react';
import PropTypes from 'prop-types';
import NutritionLabel from '../nutrition-label/nutrition-label';
import AddToCartContainer from '../add-to-cart/add-to-cart-container';
import './product-details.scss';

export default class ProductDetails extends React.Component {
  productLabels() {
    return (
      this.props.labels.map(label => (
        <div
          className="product-details-overlay"
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

  // webpack's `require` seems to have problems with interpolated strings and
  // method calls within it. using a literal string works, however.
  starImagePath() {
    const starpoints = this.props.starpoints;
    if (starpoints <= 0) {
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

  guidingStars() {
    if (!this.props.showGuidingStars) return null;
    return (
      <div className="tooltip--triangle" data-tooltip="The Guiding Stars® program evaluates the nutrient content of foods using nutrition data gleaned from the Nutrition Facts table and the ingredient list on product packaging. Click to learn more!">
        <a href="https://guidingstars.com/what-is-guiding-stars/">
          <img className="product-card-guiding-stars" src={this.starImagePath()} />
        </a>
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
            ${parseFloat(Math.round(this.props.price * 100) / 100).toFixed(2)}
          </div>
          <div className="product-details-buttons">
            <AddToCartContainer product={this.props} />
          </div>
          <div className="product-details-image-wrapper">
            <img className="product-details-image" src={this.props.awsImageUrl} />
            {this.productLabels()}
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
      labelSize: PropTypes.number
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
