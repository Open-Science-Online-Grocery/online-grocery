import { createStore } from 'redux';
import rootReducer from '.';

export default function configureStore(preloadedState) {
  return createStore(
    rootReducer,
    preloadedState,
    window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
  );
}
