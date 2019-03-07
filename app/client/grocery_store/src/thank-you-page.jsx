import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import './thank-you-page.scss';

const staticText = {
  header: 'Thank You For Your Order!',
  subheader: 'We appreciate all of your feedback on your shopping experience '
   + 'today! The following is the code to continue your Qualtrics survey:'
};

class ThankYouPage extends React.Component {
  render() {
    return (
      <div className="thank-you-page">
        <img className="logo-style" src={require('./images/howesgrocerybanner.png')} />
        <div className="thank-you-header">{staticText.header}</div>
        <div className="thank-you-subheader">{staticText.subheader}</div>
        <div className="thank-you-subheader bold">{this.props.qualtricsCode}</div>
        <Link to="/store" className="no-underline">
          <button className="back-to-shopping-button bold" type="button">Back to Shopping</button>
        </Link>
      </div>
    );
  }
}

ThankYouPage.propTypes = {
  qualtricsCode: PropTypes.string.isRequired
};

export default ThankYouPage;
