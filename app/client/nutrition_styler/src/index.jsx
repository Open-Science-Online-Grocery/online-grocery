import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import configureStore from './store/store';
import NutritionStylerContainer from './containers/NutritionStylerContainer';

export default function initialize(wrapperElement) {
  const props = { selectors: JSON.parse(wrapperElement.dataset.styles) };
  const store = configureStore(props);
  render(
    <Provider store={store}>
      <NutritionStylerContainer />
    </Provider>,
    wrapperElement
  );
}
