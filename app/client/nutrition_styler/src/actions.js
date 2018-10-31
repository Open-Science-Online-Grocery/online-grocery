export const SET_ACTIVE_SELECTOR = 'SET_ACTIVE_SELECTOR';
export const SET_STYLE = 'SET_STYLE';
export const RESET = 'RESET';

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

export function reset() {
  return { type: RESET };
}
