import { combineReducers } from 'redux-immutable';
import { SET_ACTIVE_SELECTOR } from '../actions';
import selectors, * as fromSelectors from './selectors';

/* ****************************** selectors ********************************* */
export function getCssRules($$state) {
  return fromSelectors.getCssRules($$state.get('selectors'));
}

export function getActiveSelector($$state) {
  return $$state.get('activeSelector');
}

export function getActiveRules($$state) {
  const rules = fromSelectors.getRulesForSelector(
    $$state.get('selectors'),
    getActiveSelector($$state)
  );
  return rules ? rules.toJS() : {};
}

export function getActiveOriginalRules($$state) {
  const rules = fromSelectors.getOriginalRulesForSelector(
    $$state.get('selectors'),
    getActiveSelector($$state)
  );
  return rules ? rules.toJS() : {};
}

export function getInputValue($$state) {
  return JSON.stringify(
    fromSelectors.getInputValue($$state.get('selectors')).toJS()
  );
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
  selectors
});

export default rootReducer;
