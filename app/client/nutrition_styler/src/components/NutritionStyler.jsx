import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import NutritionLabelContainer from '../containers/NutritionLabelContainer';
import StylerFormContainer from '../containers/StylerFormContainer';

export default class NutritionStyler extends PureComponent {
  render() {
    return (
      <div className="nutrition-styler">
        <div className="styler-form">
          <StylerFormContainer />
        </div>
        <div className="nutrition-label">
          <NutritionLabelContainer />
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
