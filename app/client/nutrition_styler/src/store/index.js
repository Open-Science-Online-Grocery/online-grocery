import Immutable from 'immutable';
import { combineReducers } from 'redux-immutable';

// TODO: implement this
export function getCssRules() {
  return `
    .nutrition-facts-label .fat.fact-percent {
      color: red;
    }
  `;
}

export function noOpReducer($$defaultState) {
  return ($$state = $$defaultState) => $$state;
}

const rootReducer = combineReducers({
  selectors: noOpReducer(Immutable.Map())
});

export default rootReducer;
