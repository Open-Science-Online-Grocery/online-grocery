import { getCursorPosition } from './store';

export const SELECT_TOKEN = 'SELECT_TOKEN';
export const INSERT_TOKEN = 'INSERT_TOKEN';
export const MOVE_CURSOR = 'MOVE_CURSOR';

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
