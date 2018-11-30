'use strict';

import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { PersistGate } from 'redux-persist/lib/integration/react';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import HomePage from './online-grocery-container';
import ProductViewPage from './product-page';
import CheckoutPage from './checkout-page';
import ThankYouPage from './thank-you-page';
import SessionIDPage from './session-id-container';
import { persistor, store } from './reducers/createStore';
import SearchPageContainer from './search-page-container';
import AlertContainer from './components/alert/alert-container';

export default function initialize(wrapperElement) {
  render(
    <Provider store={store}>
      <PersistGate loading={null} persistor={persistor}>
        <AlertContainer />
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
      </PersistGate>
    </Provider>,
    wrapperElement
  );
}
