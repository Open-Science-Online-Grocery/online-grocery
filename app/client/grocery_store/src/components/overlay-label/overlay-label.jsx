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
        onMouseEnter={() => this.props.handleHoverAction()}
        className="overlay-label"
        style={this.styles()}
      />
    );
  }

  tooltipLabel() {
    const { labelImageUrl, labelTooltip } = this.props;
    return (
      <Popup
        hoverable
        className="store-tooltip"
        content={labelTooltip}
        trigger={this.labelElement()}
      />
    );
  }

  render() {
    if (this.props.labelTooltip && this.props.labelTooltip.length) {
      return this.tooltipLabel();
    } else {
      return this.labelElement();
    }
  }
}

OverlayLabel.propTypes = {
  labelName: PropTypes.string,
  labelImageUrl: PropTypes.string,
  labelPosition: PropTypes.string,
  labelSize: PropTypes.number,
  labelTooltip: PropTypes.string,
  productId: PropTypes.number,
  productSerialPosition: PropTypes.number,
  handleHoverAction: PropTypes.func.isRequired,
};
