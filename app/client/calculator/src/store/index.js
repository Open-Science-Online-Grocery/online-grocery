import Immutable from 'immutable';
import { combineReducers } from 'redux-immutable';
import {
  INSERT_TOKEN,
  MOVE_CURSOR,
  REMOVE_TOKEN,
  REPORT_TEST_RESULTS
} from '../actions';

const uuidv1 = require('uuid/v1');

/* ****************************** selectors ********************************* */

export function getVariables($$state) {
  return $$state.get('variables').toJS();
}

export function getCursorPosition($$state) {
  return $$state.get('cursorPosition');
}

export function getInputName($$state) {
  return $$state.get('inputName');
}

export function getEquationType($$state) {
  return $$state.get('equationType');
}

export function getValid($$state) {
  return $$state.get('valid');
}

export function getValidationMessage($$state) {
  return $$state.get('validationMessage');
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

export function getTokensJson($$state) {
  return JSON.stringify(getTokens($$state));
}

/* ******************************* reducers ********************************* */

export function noOpReducer($$defaultState) {
  return ($$state = $$defaultState) => $$state;
}

function cursorPosition(state = 0, action) {
  switch (action.type) {
    case INSERT_TOKEN:
      return state + 1;
    case MOVE_CURSOR:
      return action.payload.forwards ? state + 1 : Math.max(state - 1, 0);
    case REMOVE_TOKEN:
      return Math.max(state - 1, 0);
    default:
      return state;
  }
}

function tokens($$state = Immutable.List(), action) {
  switch (action.type) {
    case INSERT_TOKEN:
      return $$state.insert(
        action.payload.position,
        Immutable.Map({
          id: uuidv1(), // react needs unique keys for rendering
          type: action.payload.type,
          value: action.payload.value
        })
      );
    case REMOVE_TOKEN:
      return $$state.delete(action.payload.position);
    default:
      return $$state;
  }
}

function valid(state = null, action) {
  switch (action.type) {
    case REPORT_TEST_RESULTS:
      return action.payload.valid;
    default:
      return state;
  }
}

function validationMessage(state = null, action) {
  switch (action.type) {
    case REPORT_TEST_RESULTS:
      return action.payload.validationMessage;
    default:
      return state;
  }
}

const rootReducer = combineReducers({
  cursorPosition,
  tokens,
  valid,
  validationMessage,
  variables: noOpReducer(Immutable.Map()),
  inputName: noOpReducer(''),
  equationType: noOpReducer('')
});

export default rootReducer;
