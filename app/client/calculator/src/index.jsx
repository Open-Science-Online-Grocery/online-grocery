import humps from 'humps';
import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import configureStore from './store/store';
import CalculatorContainer from './containers/CalculatorContainer';

export default function initialize(wrapperElement) {
  const tokens = JSON.parse(wrapperElement.dataset.tokens);
  const props = {
    tokens,
    variables: humps.camelizeKeys(JSON.parse(wrapperElement.dataset.variables)),
    inputName: wrapperElement.dataset.inputName,
    equationType: wrapperElement.dataset.equationType,
    cursorPosition: tokens.length
  };
  const store = configureStore(props);
  // TODO: remove next line
  if (props.equationType !== 'label') return;
  render(
    <Provider store={store}>
      <CalculatorContainer />
    </Provider>,
    wrapperElement
  );
}
