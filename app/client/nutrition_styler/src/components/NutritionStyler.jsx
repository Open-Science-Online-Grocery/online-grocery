import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import NutritionLabel from './NutritionLabel';

export default class NutritionStyler extends PureComponent {
  render() {
    return (
      <React.Fragment>
        <NutritionLabel />
        <style>
          {this.props.cssRules}
        </style>
      </React.Fragment>
    );
  }
}

NutritionStyler.propTypes = {
  cssRules: PropTypes.string.isRequired
};
