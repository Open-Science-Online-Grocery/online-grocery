import React from 'react';
import PropTypes from 'prop-types';
import NutritionLabel from '../nutrition-label/nutrition-label';
import AddToCartContainer from '../add-to-cart/add-to-cart-container';
import './product-card-expanded.scss';

export default class ProductCardExpanded extends React.Component {
  componentDidMount() {
    this.props.logParticipantAction('view', this.props.id);
  }

  // webpack's `require` seems to have problems with interpolated strings and
  // method calls within it. using a literal string works, however.
  starImagePath() {
    const starpoints = this.props.starpoints;
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

  labelStyles() {
    if (!this.props.labelImageUrl) return {};
    return {
      backgroundImage: `url(${this.props.labelImageUrl})`,
      backgroundPosition: this.props.labelPosition,
      backgroundSize: `${this.props.labelSize}%`
    };
  }

  render() {
    return (
      <div>
        <div className="product-card-expanded">
          <div>
            <div className="product-card-expanded-name">{this.props.name}</div>
            <div className="product-card-expanded-size">{this.props.size}</div>
            <div className="product-card-expanded-price bold">
              ${parseFloat(Math.round(this.props.price * 100) / 100).toFixed(2)}
            </div>
            <div className="product-card-expanded-buttons">
              <AddToCartContainer product={this.props} />
            </div>
            <div className="product-card-expanded-image-wrapper">
              <img className="product-card-expanded-image" src={this.props.imageSrc} />
              <div className="product-card-expanded-overlay" style={this.labelStyles()} />
            </div>
            <div className="product-card-expanded-description">{this.props.description}</div>
          </div>
          <div className="product-card-expanded-right-section">
            <div className="tooltip--triangle" data-tooltip="The Guiding Stars® program evaluates the nutrient content of foods using nutrition data gleaned from the Nutrition Facts table and the ingredient list on product packaging. Click to learn more!">
              <a href="https://guidingstars.com/what-is-guiding-stars/">
                <img className="product-card-guiding-stars" src={this.starImagePath()} />
              </a>
            </div>
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
            <span className="product-card-expanded-ingredients bold">INGREDIENTS: </span>
            <span className="product-card-expanded-ingredients">{this.props.ingredients}</span>
          </div>
        </div>
      </div>
    );
  }
}

ProductCardExpanded.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  starpoints: PropTypes.number,
  size: PropTypes.string.isRequired,
  price: PropTypes.string.isRequired,
  imageSrc: PropTypes.string.isRequired,
  description: PropTypes.string,
  ingredients: PropTypes.string,
  labelImageUrl: PropTypes.string,
  labelPosition: PropTypes.string,
  labelSize: PropTypes.number,
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
  logParticipantAction: PropTypes.func.isRequired
};

ProductCardExpanded.defaultProps = {
  starpoints: null,
  ingredients: null,
  labelImageUrl: null,
  labelPosition: null,
  labelSize: null,
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
