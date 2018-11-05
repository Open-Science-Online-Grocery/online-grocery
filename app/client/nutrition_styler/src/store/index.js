import { combineReducers } from 'redux-immutable';
import { SET_ACTIVE_SELECTOR } from '../actions';
import cssSelectors, * as fromCssSelectors from './cssSelectors';

/* ****************************** selectors ********************************* */
export function getCssRules($$state) {
  return fromCssSelectors.getCssRules($$state.get('cssSelectors'));
}

export function getActiveSelector($$state) {
  return $$state.get('activeSelector');
}

export function getActiveRules($$state) {
  const rules = fromCssSelectors.getRulesForSelector(
    $$state.get('cssSelectors'),
    getActiveSelector($$state)
  );
  return rules ? rules.toJS() : {};
}

export function getActiveOriginalRules($$state) {
  const rules = fromCssSelectors.getOriginalRulesForSelector(
    $$state.get('cssSelectors'),
    getActiveSelector($$state)
  );
  return rules ? rules.toJS() : {};
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
  cssSelectors
});

export default rootReducer;
