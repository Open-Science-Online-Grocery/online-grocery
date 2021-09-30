import React from 'react';
import PropTypes from 'prop-types';
import './nutrition-label.scss';

export default class NutritionLabel extends React.Component {
  makePercentage(value, dailyValue) {
    return parseFloat(Math.round(value / dailyValue * 100).toFixed(2));
  }

  isBlank(value) {
    return value === undefined || value === null || value === '';
  }

  servingsPerContainer() {
    if (this.isBlank(this.props.nutritionFacts.servings)) return null;
    return (
      <div className="nutrition-facts-servings">
        {this.props.nutritionFacts.servings} servings per container
      </div>
    );
  }

  servingSize() {
    if (this.isBlank(this.props.nutritionFacts.servingSize)) return null;
    return (
      <div className="nutrition-facts-serving-size">
        <div className="serving-size-label">Serving Size</div>
        <div className="serving-size-value">{this.props.nutritionFacts.servingSize}</div>
      </div>
    );
  }

  calories() {
    if (this.isBlank(this.props.nutritionFacts.calories)) return null;
    return (
      <div className="nutrition-facts-calories">
        <div className="calories-label">Calories</div>
        <div className="calories-value">{this.props.nutritionFacts.calories}</div>
      </div>
    );
  }

  factDiv(name, value, label, unit, dailyValue = null) {
    if (this.isBlank(value)) return null;
    return (
      <div className={`${name} nutrition-facts-line`}>
        <div className={`${name} fact-label`}>{label}</div>{' '}
        <div className={`${name} fact-value`}>{value}{unit}</div>
        {
          dailyValue
            && <div className={`${name} fact-percent`}>{this.makePercentage(value, dailyValue)}%</div>
        }
      </div>
    );
  }

  render() {
    return (
      <React.Fragment>
        <style>
          {this.props.css}
        </style>
        <div className="nutrition-facts-label">
          <div className="nutrition-facts-title">
            Nutrition Facts
          </div>
          <div className="nutrition-facts-title-divider divider" />
          {this.servingsPerContainer()}
          {this.servingSize()}
          <div className="nutrition-facts-amount">Amount per serving</div>
          <div className="nutrition-serving-size-divider divider" />
          {this.calories()}
          <div className="nutrition-calories-divider divider" />
          <div className="nutrition-facts-percent">% Daily Value</div>
          {this.factDiv('fat', this.props.nutritionFacts.totalFat, 'Total Fat', 'g', 65)}
          {this.factDiv('saturated-fat', this.props.nutritionFacts.saturatedFat, 'Saturated Fat', 'g', 20)}
          {this.factDiv('trans-fat', this.props.nutritionFacts.transFat, 'Trans Fat', 'g')}
          {this.factDiv('cholesterol', this.props.nutritionFacts.cholesterol, 'Cholesterol', 'mg', 300)}
          {this.factDiv('sodium', this.props.nutritionFacts.sodium, 'Sodium', 'mg', 2400)}
          {this.factDiv('carbs', this.props.nutritionFacts.carbs, 'Total Carbohydrate', 'g', 300)}
          {this.factDiv('fiber', this.props.nutritionFacts.fiber, 'Dietary Fiber', 'g', 25)}
          {this.factDiv('sugars', this.props.nutritionFacts.sugar, 'Sugars', 'g')}
          {this.factDiv('protein', this.props.nutritionFacts.protein, 'Protein', 'g', 50)}
          <div className="nutrition-facts-vitamins-top-divider divider" />
          <div className="nutrition-facts-vitamins">
            {(this.props.nutritionFacts.vitamins || '').replace(/% /, '%\t')}
          </div>
          <div className="nutrition-facts-vitamins-bottom-divider divider" />
          <div className="nutrition-facts-daily-value">
            The % Daily Value (DV) tells you how much a nutrient in a serving of
            food contributes to a daily diet. 2,000 calories a day is used for
            general nutrition advice.
          </div>
        </div>
      </React.Fragment>
    );
  }
}

NutritionLabel.propTypes = {
  nutritionFacts: PropTypes.shape({
    servings: PropTypes.string,
    servingSize: PropTypes.string,
    calories: PropTypes.number,
    totalFat: PropTypes.number,
    saturatedFat: PropTypes.number,
    transFat: PropTypes.number,
    cholesterol: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.number
    ]),
    sodium: PropTypes.number,
    carbs: PropTypes.number,
    fiber: PropTypes.number,
    sugar: PropTypes.number,
    protein: PropTypes.number,
    vitamins: PropTypes.string
  }).isRequired,
  css: PropTypes.string
};

NutritionLabel.defaultProps = {
  css: ''
};
