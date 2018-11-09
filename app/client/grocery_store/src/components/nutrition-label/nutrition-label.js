import React from 'react'
import './nutrition-label.scss'

var staticText = {
    dailyValue: 'The % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily ' +
    'diet. 2,000 calories a day is used for general nutrition advice.'
}

export default class NutritionLabel extends React.Component{

    formatVitamins(vitmansString) {

    }

    makePercentage(value, dailyValue) {
        return parseFloat(Math.round(value/dailyValue * 100).toFixed(2))
    }
    render() {
        return(
            <div className='nutrition-facts-label'>
                <div className='nutrition-facts-title bold'>
                    Nutrition Facts
                </div>
                <div className='nutrition-facts-servings'>
                    {this.props.nutritionFacts.servings} servings per container
                </div>
                <div className='nutrition-facts-serving-size bold'>
                    <div className='left inline'>Serving Size</div><div className='right inline'>{this.props.nutritionFacts.servingSize}</div>
                </div>
                <div className='nutrition-facts-amount bold'>
                    Amount per serving
                </div>
                <div className='nutrition-facts-calories bold'>
                    <div className='left inline'>Calories</div><div className='right inline'>{this.props.nutritionFacts.calories}</div>
                </div>
                <div className='nutrition-facts-percent bold'>
                    % Daily Value
                </div>
                <div className='nutrition-facts-line'>
                    <div className='left inline'><span className='bold'>Total Fat</span><span> {this.props.nutritionFacts.totalFat}g</span></div><div className='right inline bold'>{this.makePercentage(this.props.nutritionFacts.totalFat, 65)}%</div>
                </div>
                <div className='nutrition-facts-line indented'>
                    <div className='left inline'><span>Saturated Fat</span><span> {this.props.nutritionFacts.saturatedFat}g</span></div><div className='right inline'>{this.makePercentage(this.props.nutritionFacts.saturatedFat, 20)}%</div>
                </div>
                <div className='nutrition-facts-line indented'>
                    <div className='left inline'><span>Trans Fat</span><span> {this.props.nutritionFacts.transFat}g</span></div><div className='right inline'></div>
                </div>
                <div className='nutrition-facts-line'>
                    <div className='left inline'><span className='bold'>Cholesterol</span><span> {this.props.nutritionFacts.cholesterol}mg</span></div><div className='right inline bold'>{this.makePercentage(this.props.nutritionFacts.cholesterol, 300)}%</div>
                </div>
                <div className='nutrition-facts-line'>
                    <div className='left inline'><span className='bold'>Sodium</span><span> {this.props.nutritionFacts.sodium}mg</span></div><div className='right inline bold'>{this.makePercentage(this.props.nutritionFacts.sodium, 2400)}%</div>
                </div>
                <div className='nutrition-facts-line'>
                    <div className='left inline'><span className='bold'>Total Carbohydrate</span><span> {this.props.nutritionFacts.carbs}g</span></div><div className='right inline bold'>{this.makePercentage(this.props.nutritionFacts.carbs, 300)}%</div>
                </div>
                <div className='nutrition-facts-line indented'>
                    <div className='left inline'><span>Dietary Fiber</span><span> {this.props.nutritionFacts.fiber}g</span></div><div className='right inline'>{this.makePercentage(this.props.nutritionFacts.fiber, 25)}%</div>
                </div>
                <div className='nutrition-facts-line indented'>
                    <div className='left inline'><span>Sugars</span><span> {this.props.nutritionFacts.sugar}g</span></div>
                </div>
                <div className='nutrition-facts-line'>
                    <div className='left inline'><span className='bold'>Protein</span><span> {this.props.nutritionFacts.protein}g</span></div><div className='right inline bold'>{this.makePercentage(this.props.nutritionFacts.protein, 50)}%</div>
                </div>
                <div className='nutrition-facts-vitamins'>
                    {this.props.nutritionFacts.vitamins.replace(/% /, '%\t')}
                </div>
                <div className='nutrition-facts-daily-value'>
                    {staticText.dailyValue}
                </div>
            </div>
        )
    }
}