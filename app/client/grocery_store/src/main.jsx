'use strict';

import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import HomePage from './online-grocery-container';
import ProductViewPage from './product-page';
import CheckoutPage from './checkout-page';
import ThankYouPage from './thank-you-page';
import SessionIDPage from './session-id-container';
import store from './reducers/createStore';
import SearchPageContainer from './search-page-container';

export default function initialize(wrapperElement) {
  render(
    <Provider store={store}>
      <Router>
        <Switch>
          <Route exact path="/store" component={SessionIDPage} />
          <Route path="/store/home" component={HomePage} />
          <Route path="/store/product" component={ProductViewPage} />
          <Route path="/store/search" component={SearchPageContainer} />
          <Route path="/store/checkout" component={CheckoutPage} />
          <Route path="/store/thank-you" component={ThankYouPage} />
        </Switch>
      </Router>
    </Provider>,
    wrapperElement
  );
}