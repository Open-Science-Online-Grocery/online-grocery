import Immutable from 'immutable';
import { combineReducers } from 'redux-immutable';
import { INSERT_TOKEN } from '../actions';

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
  const tokensArray = getTokens($$state);
  return tokensArray.map(
    token => Object.assign(token, { name: getTokenName($$state, token) })
  );
}

/* ******************************* reducers ********************************* */

export function noOpReducer($$defaultState) {
  return ($$state = $$defaultState) => $$state;
}

function cursorPosition(state = 0, action) {
  switch (action.type) {
    case INSERT_TOKEN:
      return state + 1;
    default:
      return state;
  }
}

function tokens($$state = Immutable.List(), action) {
  switch (action.type) {
    case INSERT_TOKEN:
      return $$state.set(
        action.payload.position,
        Immutable.Map({
          type: action.payload.type,
          value: action.payload.value
        })
      );
    default:
      return $$state;
  }
}

const rootReducer = combineReducers({
  cursorPosition,
  tokens,
  variables: noOpReducer(Immutable.Map())
});

export default rootReducer;
