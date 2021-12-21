import React from 'react';
import PropTypes from 'prop-types';
import './error-message.scss';

export default class ErrorMessage extends React.Component {
  render () {
    if (!this.props.visible || !this.props.message) return null;
    return (
      <div className="main-error-message">
        {this.props.message}
      </div>
    );
  }
}
