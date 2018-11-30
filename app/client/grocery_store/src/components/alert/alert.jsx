import React from 'react';
import PropTypes from 'prop-types';
import './alert.scss';

export default class Alert extends React.Component {
  render() {
    if (!this.props.visible || !this.props.message) return null;
    return (
      <div className="alert">
        <div className="modal-background">
          <div className="modal-window">

            <div className="header">
              <button type="button" onClick={this.props.handleDismiss}>
                &times;
              </button>
              <div className="title">Alert</div>
            </div>

            <div className="message">
              {this.props.message}
            </div>

          </div>
        </div>
      </div>
    );
  }
}

Alert.propTypes = {
  message: PropTypes.string,
  visible: PropTypes.bool,
  handleDismiss: PropTypes.func.isRequired
};

Alert.defaultProps = {
  message: null,
  visible: false
};
