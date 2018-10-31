import Immutable from 'immutable';
import { SET_STYLE } from '../actions';
import CssWriter from '../utils/CssWriter';

export function getRulesForSelector($$state, selector) {
  return $$state.getIn([selector, 'rules']);
}

export function getCssRules($$state) {
  let cssString = '';
  $$state.keySeq().forEach(
    (selector) => {
      const rules = getRulesForSelector($$state, selector).toJS();
      cssString += new CssWriter(selector, rules).cssString();
    }
  );
  return cssString;
}

export default function selectors($$state = Immutable.Map(), action) {
  switch (action.type) {
    case SET_STYLE:
      return $$state.setIn(
        [action.payload.activeSelector, 'rules', action.payload.property],
        action.payload.value
      );
    default:
      return $$state;
  }
}
