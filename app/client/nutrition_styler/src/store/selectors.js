import Immutable from 'immutable';
import { SET_STYLE, RESET_SELECTION, SET_ACTIVE_SELECTOR } from '../actions';
import CssWriter from '../utils/CssWriter';
import CssToRulesConverter from '../utils/CssToRulesConverter';

export function getRulesForSelector($$state, selector) {
  return $$state.getIn([selector, 'rules']) || Immutable.Map();
}

export function getOriginalRulesForSelector($$state, selector) {
  return $$state.getIn([selector, 'originalRules']);
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
    case SET_ACTIVE_SELECTOR: {
      const selector = action.payload.activeSelector;
      if (selector && !$$state.get(selector)) {
        const converter = new CssToRulesConverter(selector);
        return $$state.setIn(
          [selector, 'originalRules'],
          Immutable.fromJS(converter.rules())
        );
      }
      return $$state;
    }
    case SET_STYLE:
      return $$state.setIn(
        [action.payload.activeSelector, 'rules', action.payload.property],
        action.payload.value
      );
    case RESET_SELECTION:
      return $$state.setIn(
        [action.payload.activeSelector, 'rules'],
        Immutable.Map()
      );
    default:
      return $$state;
  }
}
