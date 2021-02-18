import React from 'react';
import PropTypes from 'prop-types';
import { Popup } from 'semantic-ui-react'
import './below-button-label.scss';


export default class BelowButtonLabel extends React.Component {
  styles() {
    const { labelImageUrl, labelSize } = this.props;
    if (!labelImageUrl) return {};
    return { width: `${labelSize}%` };
  }

  labelElement() {
    return (
      <img src={this.props.labelImageUrl} style={this.styles()} />
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
      <div className="below-button-container">
        { this.props.labelTooltip.length ? this.tooltipLabel() : this.labelElement() }
      </div>
    );
  }
}

BelowButtonLabel.propTypes = {
  labelImageUrl: PropTypes.string,
  labelSize: PropTypes.number,
  labelTooltip: PropTypes.string
};
