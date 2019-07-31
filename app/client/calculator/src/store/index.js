import Immutable from 'immutable';
import { combineReducers } from 'redux-immutable';
// TODO: resolve below when time permits
// eslint-disable-next-line import/no-cycle
import {
  INSERT_TOKEN,
  MOVE_CURSOR,
  REMOVE_TOKEN,
  REPORT_TEST_RESULTS,
  SET_CALCULATOR_FOCUS
} from '../actions';

const uuidv1 = require('uuid/v1');

/* ****************************** selectors ********************************* */

export function getVariables($$state) {
  return $$state.get('variables').toJS();
}

function getVariable($$state, token) {
  return getVariables($$state).find(variable => variable.token === token.value);
}

export function getCursorPosition($$state) {
  return $$state.get('cursorPosition');
}

export function getCalculatorFocus($$state) {
  return $$state.get('calculatorFocus');
}

export function getInputName($$state) {
  return $$state.get('inputName');
}

export function getEquationType($$state) {
  return $$state.get('equationType');
}

export function getConditionId($$state) {
  return $$state.get('conditionId');
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

export function getTokenCount($$state) {
  return $$state.get('tokens').size;
}

function getTokenName($$state, token) {
  if (token.type !== 'variable') return null;
  return getVariable($$state, token).description;
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

export function getIncompleteDataVariables($$state) {
  const variableTokens = getTokens($$state).filter(
    token => token.type === 'variable'
  );
  const variables = variableTokens.map(token => getVariable($$state, token));
  const uniqueVariables = Array.from(new Set(variables));
  return uniqueVariables
    .filter(variable => variable.incompleteData)
    .map(variable => variable.description);
}

/* ******************************* reducers ********************************* */

export function noOpReducer($$defaultState) {
  return ($$state = $$defaultState) => $$state;
}

// cursorPosition indicates where, relative to the array of tokens, the cursor
// should appear in the EquationEditor, using a 0-based index. E.g., a position
// of 0 indicates the cursor should appear before any tokens while a position of
// 3 indicates the cursor should appear after the first 3 tokens.
export function cursorPosition(state = 0, action) {
  switch (action.type) {
    case INSERT_TOKEN:
      return state + 1;
    case MOVE_CURSOR:
      if (action.payload.shouldMoveForwards) {
        return Math.min(state + 1, action.payload.tokenCount);
      }
      return Math.max(state - 1, 0);
    case REMOVE_TOKEN:
      return Math.max(state - 1, 0);
    default:
      return state;
  }
}

export function calculatorFocus(state = false, action) {
  switch (action.type) {
    case SET_CALCULATOR_FOCUS:
      return action.payload.calculatorFocus;
    default:
      return state;
  }
}

export function tokens($$state = Immutable.List(), action) {
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

export function valid(state = null, action) {
  switch (action.type) {
    case REPORT_TEST_RESULTS:
      return action.payload.valid;
    case INSERT_TOKEN:
      return null;
    case REMOVE_TOKEN:
      return null;
    default:
      return state;
  }
}

export function validationMessage(state = null, action) {
  switch (action.type) {
    case REPORT_TEST_RESULTS:
      return action.payload.validationMessage;
    case INSERT_TOKEN:
      return null;
    case REMOVE_TOKEN:
      return null;
    default:
      return state;
  }
}

const rootReducer = combineReducers({
  cursorPosition,
  calculatorFocus,
  tokens,
  valid,
  validationMessage,
  variables: noOpReducer(Immutable.Map()),
  inputName: noOpReducer(''),
  equationType: noOpReducer(''),
  conditionId: noOpReducer('')
});

export default rootReducer;
