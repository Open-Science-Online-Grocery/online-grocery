import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import NutritionLabel from '../../../grocery_store/src/components/nutrition-label/nutrition-label';

export const hoverClassName = 'hovered';
export const selectedClassName = 'selected';

export default class NutritionLabelPreview extends PureComponent {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  componentWillMount() {
    document.addEventListener('mousedown', this.handleClick, false);
  }

  componentWillUnmount() {
    document.removeEventListener('mousedown', this.handleClick, false);
  }

  getActiveSelector(element) {
    const classes = Array.from(element.classList);
    // we remove the hover and selected class names because they are temporary
    // and won't help us identify the target element later.
    if (element.classList.contains(hoverClassName)) {
      classes.splice(classes.indexOf(hoverClassName), 1);
    }
    if (element.classList.contains(selectedClassName)) {
      classes.splice(classes.indexOf(selectedClassName), 1);
    }
    return `.${classes.join('.')}`;
  }

  handleMouseOver(event) {
    event.target.classList.add(hoverClassName);
  }

  handleMouseOut(event) {
    event.target.classList.remove(hoverClassName);
  }

  handleClick(event) {
    if (event.target.closest('.styler-form')) return;
    document.querySelectorAll(`.${selectedClassName}`).forEach(
      element => element.classList.remove(selectedClassName)
    );
    if (this.node.contains(event.target)) {
      this.props.setActiveSelector(this.getActiveSelector(event.target));
      event.target.classList.add(selectedClassName);
    } else {
      this.props.setActiveSelector(null);
    }
  }

  fakeProductData() {
    return {
      servings: '8',
      servingSize: '2/3 cup (55g)',
      calories: 230,
      totalFat: 8,
      saturatedFat: 1,
      transFat: 0,
      cholesterol: 0,
      sodium: 160,
      carbs: 37,
      fiber: 4,
      sugar: 12,
      protein: 3,
      vitamins: '4% Vitamin A 0% Vitamin C 2% Calcium 4% Iron'
    };
  }

  render() {
    return (
      <div
        ref={(node) => { this.node = node; }}
        onMouseOver={this.handleMouseOver}
        onFocus={this.handleMouseOver}
        onMouseOut={this.handleMouseOut}
        onBlur={this.handleMouseOut}
      >
        <NutritionLabel nutritionFacts={this.fakeProductData()} css={this.props.cssRules} />
      </div>
    );
  }
}

NutritionLabelPreview.propTypes = {
  setActiveSelector: PropTypes.func.isRequired,
  cssRules: PropTypes.string.isRequired
};
