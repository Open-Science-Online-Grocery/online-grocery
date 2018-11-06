import Immutable from 'immutable';
import { combineReducers } from 'redux-immutable';

/* ****************************** selectors ********************************* */

export function getVariables($$state) {
  return $$state.get('variables').toJS();
}

export function getCursorPosition($$state) {
  return $$state.get('cursorPosition');
}

function getTokens($$state) {
  return $$state.get('tokens').toJS();
}

function getTokenName($$state, token) {
  if (token.type !== 'variable') return null;
  return getVariables($$state)[token.value];
}

export function getTokensWithName($$state) {
  const tokens = getTokens($$state);
  return tokens.map(
    token => Object.assign(token, { name: getTokenName($$state, token) })
  );
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
