import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import configureStore from './store/store';
import Calculator from './components/Calculator';

export default function initialize(wrapperElement) {
  const props = { variables: JSON.parse(wrapperElement.dataset.variables) };
  const store = configureStore(props);
  render(
    <Provider store={store}>
      <Calculator />
    </Provider>,
    wrapperElement
  );
}
