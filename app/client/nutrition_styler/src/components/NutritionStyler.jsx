import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import NutritionLabel from './NutritionLabel';
import StylerForm from './StylerForm';

export default class NutritionStyler extends PureComponent {
  render() {
    return (
      <div className="nutrition-styler">
        <div className="styler-form">
          <StylerForm />
        </div>
        <div className="nutrition-label">
          <NutritionLabel />
          <style>
            {this.props.cssRules}
          </style>
        </div>
      </div>
    );
  }
}

NutritionStyler.propTypes = {
  cssRules: PropTypes.string.isRequired
};
