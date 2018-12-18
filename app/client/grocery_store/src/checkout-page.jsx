import React from 'react';
import { Route } from 'react-router-dom';
import OrderSummaryContainer from './components/checkout/order-summary/order-summary-container';
import './checkout-page.scss';

export default class CheckoutPage extends React.Component {
  render() {
    return (
      <div>
        <img
          className="logo-style"
          src={
            require('./images/howesgrocerybanner.png')
          }
        />
        <div className="checkout-title">Checkout</div>
        <Route
          render={
            ({ history }) => (
              <form className="checkout-sections">
                <OrderSummaryContainer onSubmit={() => history.push('/store/thank-you')} />
              </form>
            )
          }
        />
      </div>
    );
  }
}
