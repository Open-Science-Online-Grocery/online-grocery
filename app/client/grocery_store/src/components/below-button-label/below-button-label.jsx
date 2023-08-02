import React from 'react';
import PropTypes from 'prop-types';
import { Popup } from 'semantic-ui-react';
import './below-button-label.scss';

export default class BelowButtonLabel extends React.Component {
  styles() {
    const { labelImageUrl, labelSize } = this.props;
    if (!labelImageUrl) return {};
    return { width: `${labelSize}%` };
  }

  labelElement() {
    return (
      <img
        onMouseEnter={() => this.props.handleHoverAction()}
        src={this.props.labelImageUrl}
        style={this.styles()}
      />
    );
  }

  tooltipLabel() {
    const { labelTooltip } = this.props;
    return (
      <Popup
        hoverable
        className="store-tooltip"
        content={labelTooltip}
        trigger={this.labelElement()}
      />
    );
  }

  element() {
    if (this.props.labelTooltip && this.props.labelTooltip.length) {
      return this.tooltipLabel();
    } else {
      return this.labelElement();
    }
  }

  render() {
    return (
      <div className="below-button-container">
        {this.element()}
      </div>
    );
  }
}

BelowButtonLabel.propTypes = {
  labelImageUrl: PropTypes.string,
  labelSize: PropTypes.number,
  labelTooltip: PropTypes.string,
  productId: PropTypes.number,
  productSerialPosition: PropTypes.number,
  handleHoverAction: PropTypes.func.isRequired
};
