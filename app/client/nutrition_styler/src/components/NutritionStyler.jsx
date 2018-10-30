import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import NutritionLabel from './NutritionLabel';

export default class NutritionStyler extends PureComponent {
  render() {
    return (
      <div>
        <NutritionLabel />
        <style>
          {this.props.cssRules}
        </style>
      </div>
    );
  }
}

NutritionStyler.propTypes = {
  cssRules: PropTypes.string.isRequired
};
