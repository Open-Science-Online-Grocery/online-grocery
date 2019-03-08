import FlashMessage from '../../utils/FlashMessage';
import { equationValidation } from '../../utils/routes';
import * as fromApi from '../../utils/api_call';
import {
  getCursorPosition,
  getEquationType,
  getConditionId,
  getTokensJson,
  getTokenCount
} from './store';

export const INSERT_TOKEN = 'INSERT_TOKEN';
export const MOVE_CURSOR = 'MOVE_CURSOR';
export const REMOVE_TOKEN = 'REMOVE_TOKEN';
export const REPORT_TEST_RESULTS = 'REPORT_TEST_RESULTS';
export const SET_CALCULATOR_FOCUS = 'SET_CALCULATOR_FOCUS';

function insertToken(type, value, position) {
  return {
    type: INSERT_TOKEN,
    payload: { type, value, position }
  };
}

export function setCalculatorFocus(calculatorFocus) {
  return {
    type: SET_CALCULATOR_FOCUS,
    payload: { calculatorFocus }
  };
}

export function selectToken(type, value) {
  return (dispatch, getState) => {
    const $$state = getState();
    dispatch(insertToken(type, value, getCursorPosition($$state)));
  };
}

function moveCursor(shouldMoveForwards, tokenCount) {
  return {
    type: MOVE_CURSOR,
    payload: { shouldMoveForwards, tokenCount }
  };
}

export function arrowKeyPressed(shouldMoveForwards) {
  return (dispatch, getState) => {
    const $$state = getState();
    dispatch(moveCursor(shouldMoveForwards, getTokenCount($$state)));
  };
}

function removeToken(position) {
  return {
    type: REMOVE_TOKEN,
    payload: { position }
  };
}

export function deletePreviousToken() {
  return (dispatch, getState) => {
    const $$state = getState();
    dispatch(removeToken(getCursorPosition($$state) - 1));
  };
}


function testCalculationFailure(error) {
  new FlashMessage(
    'error',
    'There was a problem testing the calculation:',
    [error]
  ).showFlash();
}

function reportTestResults(testResults) {
  return {
    type: REPORT_TEST_RESULTS,
    payload: {
      valid: testResults.data.valid,
      validationMessage: testResults.errors.map(e => e.title).join(', ')
    }
  };
}

export function testCalculation() {
  return (dispatch, getState) => {
    const $$state = getState();
    const data = {
      type: getEquationType($$state),
      tokens: getTokensJson($$state),
      conditionId: getConditionId($$state)
    };
    const route = equationValidation();
    const success = json => dispatch(reportTestResults(json));
    return fromApi.jsonApiCall(route, data, success, testCalculationFailure);
  };
}
