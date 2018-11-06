import Immutable from 'immutable';
import { combineReducers } from 'redux-immutable';

/* ****************************** selectors ********************************* */

export function getVariables($$state) {
  return $$state.get('variables').toJS();
}

/* ******************************* reducers ********************************* */

export function noOpReducer($$defaultState) {
  return ($$state = $$defaultState) => $$state;
}

const rootReducer = combineReducers({
  variables: noOpReducer(Immutable.Map()),
  cursorPosition: noOpReducer(0), // TODO,
  tokens: noOpReducer(Immutable.List()) // TODO
});

export default rootReducer;
