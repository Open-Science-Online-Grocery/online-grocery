import humps from 'humps';
import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import configureStore from './store/store';
import CalculatorContainer from './containers/CalculatorContainer';

export default function initialize(wrapperElement) {
  const tokens = JSON.parse(wrapperElement.dataset.tokens);
  let conditionId = null;
  if (wrapperElement.dataset.conditionId) {
    conditionId = JSON.parse(wrapperElement.dataset.conditionId);
  }
  const props = {
    tokens,
    variables: humps.camelizeKeys(JSON.parse(wrapperElement.dataset.variables)),
    conditionId,
    inputName: wrapperElement.dataset.inputName,
    equationType: wrapperElement.dataset.equationType,
    cursorPosition: tokens.length,
    calculatorFocus: false
  };
  const store = configureStore(props);
  render(
    <Provider store={store}>
      <CalculatorContainer />
    </Provider>,
    wrapperElement
  );
}
