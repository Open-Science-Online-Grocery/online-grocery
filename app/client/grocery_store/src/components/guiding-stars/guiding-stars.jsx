import React from 'react';
import PropTypes from 'prop-types';
import { Popup } from 'semantic-ui-react'

export default class GuidingStars extends React.Component {
  // webpack's `require` seems to have problems with interpolated strings and
  // method calls within it. using a literal string works, however.
  starImagePath() {
    const starpoints = this.props.starpoints;
    if (starpoints <= 0) {
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

  render() {
    return (
      <Popup
        hoverable
        wide="very"
        content="The Guiding Stars® program evaluates the nutrient content of foods using nutrition data gleaned from the Nutrition Facts table and the ingredient list on product packaging. Click to learn more!"
        trigger={
          <a href="https://guidingstars.com/what-is-guiding-stars/">
            <img className="product-card-guiding-stars" src={this.starImagePath()} />
          </a>
        }
      />
    );
  }
}

GuidingStars.propTypes = {
  starpoints: PropTypes.number
};

GuidingStars.defaultProps = {
  starpoints: null
};
