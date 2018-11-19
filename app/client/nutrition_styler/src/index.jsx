import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import configureStore from './store/store';
import NutritionStyler from './components/NutritionStyler';

export default function initialize(wrapperElement) {
  const props = { cssSelectors: JSON.parse(wrapperElement.dataset.styles) };
  const store = configureStore(props);
  render(
    <Provider store={store}>
      <NutritionStyler />
    </Provider>,
    wrapperElement
  );
}
