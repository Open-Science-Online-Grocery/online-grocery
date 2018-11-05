import Immutable from 'immutable';
import { combineReducers } from 'redux-immutable';

export function noOpReducer($$defaultState) {
  return ($$state = $$defaultState) => $$state;
}

const rootReducer = combineReducers({
  variables: noOpReducer(Immutable.Map()),
  cursorPosition: noOpReducer(0), // TODO,
  tokens: noOpReducer(Immutable.List()) // TODO
});

export default rootReducer;
