import { getCursorPosition } from './store';

export const SELECT_TOKEN = 'SELECT_TOKEN';
export const INSERT_TOKEN = 'INSERT_TOKEN';
export const MOVE_CURSOR = 'MOVE_CURSOR';
export const DELETE_PREVIOUS_TOKEN = 'DELETE_PREVIOUS_TOKEN';
export const REMOVE_TOKEN = 'REMOVE_TOKEN';

function insertToken(type, value, position) {
  return {
    type: INSERT_TOKEN,
    payload: { type, value, position }
  };
}

export function selectToken(type, value) {
  return (dispatch, getState) => {
    const $$state = getState();
    dispatch(insertToken(type, value, getCursorPosition($$state)));
  };
}

export function moveCursor(forwards) {
  return {
    type: MOVE_CURSOR,
    payload: { forwards }
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
