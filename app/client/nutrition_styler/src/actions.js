export const SET_ACTIVE_SELECTOR = 'SET_ACTIVE_SELECTOR';
export const SET_STYLE = 'SET_STYLE';
export const RESET_SELECTION = 'RESET_SELECTION';
export const RESET_ALL = 'RESET_ALL';

export function setActiveSelector(activeSelector) {
  return {
    type: SET_ACTIVE_SELECTOR,
    payload: { activeSelector }
  };
}

export function setStyle(activeSelector, property, value) {
  return {
    type: SET_STYLE,
    payload: { activeSelector, property, value }
  };
}

export function resetSelection(activeSelector) {
  return {
    type: RESET_SELECTION,
    payload: { activeSelector }
  };
}

export function resetAll() {
  return { type: RESET_ALL };
}
