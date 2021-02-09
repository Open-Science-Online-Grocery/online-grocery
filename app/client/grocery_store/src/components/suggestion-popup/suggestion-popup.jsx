import React from 'react';
import PropTypes from 'prop-types';
import ProductDetailsContainer from '../product-details/product-details-container';
import './suggestion-popup.scss';

export default class SuggestionPopup extends React.Component {
  render() {
    if (!this.props.visible) return null;
    return (
      <div className="suggestion-popup">
        <div className="modal-background">
          <div className="modal-window">
            <div className="header">
              <button type="button" onClick={this.props.handleDismiss}>
                &times;
              </button>
              <div className="title">{this.props.title}</div>
            </div>
            <div className="body">
              <ProductDetailsContainer {...this.props.product} />
            </div>
          </div>
        </div>
      </div>
    );
  }
}

SuggestionPopup.propTypes = {
  title: PropTypes.string,
  visible: PropTypes.bool,
  handleDismiss: PropTypes.func.isRequired,
  product: PropTypes.shape({
    name: PropTypes.string,
    imageSrc: PropTypes.string,
    awsImageUrl: PropTypes.string,
    size: PropTypes.string,
    price: PropTypes.string,
    starpoints: PropTypes.number,
    labels: PropTypes.arrayOf(
      PropTypes.shape({
        labelName: PropTypes.string,
        labelImageUrl: PropTypes.string,
        labelPosition: PropTypes.string,
        labelSize: PropTypes.number
      })
    )
  })
};

SuggestionPopup.defaultProps = {
  visible: false,
  title: null
};
