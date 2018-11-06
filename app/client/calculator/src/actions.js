import { getCursorPosition } from './store';

export const SELECT_TOKEN = 'SELECT_TOKEN';
export const INSERT_TOKEN = 'INSERT_TOKEN';

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
