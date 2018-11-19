import React from 'react';
import PropTypes from 'prop-types';
import './nutrition-label.scss';

export default class NutritionLabel extends React.Component {
  makePercentage(value, dailyValue) {
    return parseFloat(Math.round(value / dailyValue * 100).toFixed(2));
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

          <div className="nutrition-facts-servings">
            {this.props.nutritionFacts.servings} servings per container
          </div>
          <div className="nutrition-facts-serving-size">
            <div className="serving-size-label">Serving Size</div>
            <div className="serving-size-value">{this.props.nutritionFacts.servingSize}</div>
          </div>
          <div className="nutrition-facts-amount">
            Amount per serving
          </div>
          <div className="nutrition-serving-size-divider divider" />

          <div className="nutrition-facts-calories">
            <div className="calories-label">Calories</div>
            <div className="calories-value">{this.props.nutritionFacts.calories}</div>
          </div>
          <div className="nutrition-calories-divider divider" />

          <div className="nutrition-facts-percent">
            % Daily Value
          </div>
          <div className="fat nutrition-facts-line">
            <div className="fat fact-label">Total Fat</div>{' '}
            <div className="fat fact-value">{this.props.nutritionFacts.totalFat}g</div>
            <div className="fat fact-percent">{this.makePercentage(this.props.nutritionFacts.totalFat, 65)}%</div>
          </div>
          <div className="saturated-fat nutrition-facts-line">
            <div className="saturated-fat fact-label">Saturated Fat</div>{' '}
            <div className="saturated-fat fact-value">{this.props.nutritionFacts.saturatedFat}g</div>
            <div className="saturated-fat fact-percent">{this.makePercentage(this.props.nutritionFacts.saturatedFat, 20)}%</div>
          </div>
          <div className="trans-fat nutrition-facts-line">
            <div className="trans-fat fact-label">Trans Fat</div>{' '}
            <div className="trans-fat fact-value">{this.props.nutritionFacts.transFat}g</div>
          </div>
          <div className="cholesterol nutrition-facts-line">
            <div className="cholesterol fact-label">Cholesterol</div>{' '}
            <div className="cholesterol fact-value">{this.props.nutritionFacts.cholesterol}mg</div>
            <div className="cholesterol fact-percent">{this.makePercentage(this.props.nutritionFacts.cholesterol, 300)}%</div>
          </div>
          <div className="sodium nutrition-facts-line">
            <div className="sodium fact-label">Sodium</div>{' '}
            <div className="sodium fact-value">{this.props.nutritionFacts.sodium}mg</div>
            <div className="sodium fact-percent">{this.makePercentage(this.props.nutritionFacts.sodium, 2400)}%</div>
          </div>
          <div className="carbs nutrition-facts-line">
            <div className="carbs fact-label">Total Carbohydrate</div>{' '}
            <div className="carbs fact-value">{this.props.nutritionFacts.carbs}g</div>
            <div className="carbs fact-percent">{this.makePercentage(this.props.nutritionFacts.sodium, 2400)}%</div>
          </div>
          <div className="fiber nutrition-facts-line">
            <div className="fiber fact-label">Dietary Fiber</div>{' '}
            <div className="fiber fact-value">{this.props.nutritionFacts.fiber}g</div>
            <div className="fiber fact-percent">{this.makePercentage(this.props.nutritionFacts.fiber, 25)}%</div>
          </div>
          <div className="sugars nutrition-facts-line">
            <div className="sugars fact-label">Sugars</div>{' '}
            <div className="sugars fact-value">{this.props.nutritionFacts.sugar}g</div>
          </div>
          <div className="protein nutrition-facts-line">
            <div className="protein fact-label">Protein</div>{' '}
            <div className="protein fact-value">{this.props.nutritionFacts.protein}g</div>
            <div className="protein fact-percent">{this.makePercentage(this.props.nutritionFacts.protein, 50)}%</div>
          </div>

          <div className="nutrition-facts-vitamins-top-divider divider" />
          <div className="nutrition-facts-vitamins">
            {this.props.nutritionFacts.vitamins.replace(/% /, '%\t')}
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
