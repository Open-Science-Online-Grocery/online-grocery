export const SET_ACTIVE_SELECTOR = 'SET_ACTIVE_SELECTOR';
export const SET_STYLE = 'SET_STYLE';
export const TOGGLE_LIST_STYLE = 'TOGGLE_LIST_STYLE';
export const APPLY_STYLES = 'APPLY_STYLES';
export const RESET = 'RESET';

export function setActiveSelector(activeSelector) {
  return {
    type: SET_ACTIVE_SELECTOR,
    payload: { activeSelector }
  };
}

// used for CSS rules where we are setting the value as a whole (like
// `font_size: 8px`)
export function setStyle(property, value) {
  return {
    type: SET_STYLE,
    payload: { property, value }
  };
}

// used for CSS rules where the value is a list and we are only adding/removing
// a single element in the list at a time (like `text-decoration:
// line-through, underline`).  only one value (like `underline`) is passed to
// this function at a time.
export function setListStyle(property, value) {
  return {
    type: TOGGLE_LIST_STYLE,
    payload: { property, value }
  };
}

export function applyStyles() {
  return { type: APPLY_STYLES };
}

export function reset() {
  return { type: RESET };
}
