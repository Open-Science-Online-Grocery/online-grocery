import Immutable from 'immutable';
import { combineReducers } from 'redux-immutable';
import { SET_ACTIVE_SELECTOR } from '../actions';

/* ****************************** selectors ********************************* */
// TODO: implement this
export function getCssRules() {
  return `
    .nutrition-facts-label .fat.fact-percent {
      color: red;
    }
  `;
}

export function getActiveSelector($$state) {
  return $$state.get('activeSelector');
}

/* ******************************* reducers ********************************* */
export function noOpReducer($$defaultState) {
  return ($$state = $$defaultState) => $$state;
}

function activeSelector(state = null, action) {
  switch (action.type) {
    case SET_ACTIVE_SELECTOR:
      return action.payload.activeSelector;
    default:
      return state;
  }
}

const rootReducer = combineReducers({
  activeSelector,
  selectors: noOpReducer(Immutable.Map())
});

export default rootReducer;
