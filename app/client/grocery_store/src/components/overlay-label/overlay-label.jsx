import React from 'react';
import PropTypes from 'prop-types';
import { Popup } from 'semantic-ui-react'
import './overlay-label.scss';

export default class OverlayLabel extends React.Component {
  styles() {
    const { labelImageUrl, labelPosition, labelSize } = this.props;
    if (!labelImageUrl) return {};
    return {
      backgroundImage: `url(${labelImageUrl})`,
      backgroundPosition: labelPosition,
      backgroundSize: `${labelSize}%`
    };
  }

  labelElement() {
    return (
      <div
        className="overlay-label"
        style={this.styles()}
      />
    );
  }

  tooltipLabel() {
    const { labelImageUrl, labelTooltip } = this.props;
    return (
      <Popup
        content={labelTooltip}
        trigger={this.labelElement()}
      />
    );
  }

  render() {
    return (
      this.props.labelTooltip.length ? this.tooltipLabel() : this.labelElement()
    );
  }
}

OverlayLabel.propTypes = {
  labelName: PropTypes.string,
  labelImageUrl: PropTypes.string,
  labelPosition: PropTypes.string,
  labelSize: PropTypes.number,
  labelTooltip: PropTypes.string,
  labelBelowButton: PropTypes.bool
};
