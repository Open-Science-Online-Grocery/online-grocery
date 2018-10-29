import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

export default class NutritionLabel extends PureComponent {
  render() {
    return (
      <div className="nutrition-facts-label">
        <div className="nutrition-facts-title">
          Nutrition Facts
        </div>
        <div className="nutrition-facts-servings">
          8 servings per container
        </div>
        <div className="nutrition-facts-serving-size">
          <div className="serving-size-label">Serving Size</div><div className="serving-size-value">2/3 cup (55g)</div>
        </div>
        <div className="nutrition-facts-amount">
          Amount per serving
        </div>
        <div className="nutrition-facts-calories">
          <div className="calories-label">Calories</div><div className="calories-value">230</div>
        </div>
        <div className="nutrition-facts-percent">
          % Daily Value
        </div>
        <div className="nutrition-facts-line">
          <div className="fat fact-label">Total Fat</div>
          <div className="fat fact-value">8g</div>
          <div className="fat fact-percent">10%</div>
        </div>
        <div className="nutrition-facts-line">
          <div className="saturated-fat fact-label">Saturated Fat</div>
          <div className="saturated-fat fact-value">1g</div>
          <div className="saturated-fat fact-percent">5%</div>
        </div>
        <div className="nutrition-facts-line">
          <div className="trans-fat fact-label">Trans Fat</div>
          <div className="trans-fat fact-value">0g</div>
        </div>
        <div className="nutrition-facts-line">
          <div className="cholesterol fact-label">Cholesterol</div>
          <div className="cholesterol fact-value">0mg</div>
          <div className="cholesterol fact-percent">0%</div>
        </div>
        <div className="nutrition-facts-line">
          <div className="sodium fact-label">Sodium</div>
          <div className="sodium fact-value">160mg</div>
          <div className="sodium fact-percent">7%</div>
        </div>
        <div className="nutrition-facts-line">
          <div className="carbs fact-label">Total Carbohydrate</div>
          <div className="carbs fact-value">37g</div>
          <div className="carbs fact-percent">13%</div>
        </div>
        <div className="nutrition-facts-line">
          <div className="fiber fact-label">Dietary Fiber</div>
          <div className="fiber fact-value">4g</div>
          <div className="fiber fact-percent">14%</div>
        </div>
        <div className="nutrition-facts-line">
          <div className="sugars fact-label">Sugars</div>
          <div className="sugars fact-value">12g</div>
        </div>
        <div className="nutrition-facts-line">
          <div className="protein fact-label">Protein</div>
          <div className="protein fact-value">3g</div>
          <div className="protein fact-percent">6%</div>
        </div>
        <div className="nutrition-facts-vitamins">
          <div className="vitamin-facts-line">
            <div className="vitamin-d fact-label">Vitamin D</div>
            <div className="vitamin-d fact-value">2mcg</div>
            <div className="vitamin-d fact-percent">10%</div>
          </div>
          <div className="vitamin-facts-line">
            <div className="calcium fact-label">Calcium</div>
            <div className="calcium fact-value">260mg</div>
            <div className="calcium fact-percent">20%</div>
          </div>
          <div className="vitamin-facts-line">
            <div className="iron fact-label">Iron</div>
            <div className="iron fact-value">260mg</div>
            <div className="iron fact-percent">10%</div>
          </div>
          <div className="vitamin-facts-line">
            <div className="potassium fact-label">Potassium</div>
            <div className="potassium fact-value">235mg</div>
            <div className="potassium fact-percent">6%</div>
          </div>
        </div>
        <div className="nutrition-facts-daily-value">
          The % Daily Value (DV) tells you how much a nutrient in a serving of
          food contributes to a daily diet. 2,000 calories a day is used for
          general nutrition advice.
        </div>
      </div>
    );
  }
}
