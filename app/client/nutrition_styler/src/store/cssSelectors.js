import Immutable from 'immutable';
import CssWriter from '../utils/CssWriter';
import CssToRulesConverter from '../utils/CssToRulesConverter';
import {
  SET_STYLE,
  RESET_SELECTION,
  SET_ACTIVE_SELECTOR,
  RESET_ALL
} from '../actions';

export function getRulesForSelector($$state, selector) {
  return $$state.getIn([selector, 'rules']) || Immutable.Map();
}

export function getOriginalRulesForSelector($$state, selector) {
  return $$state.getIn([selector, 'originalRules']);
}

export function getCssRules($$state) {
  return new CssWriter($$state.toJS()).cssString();
}

export function getInputValue($$state) {
  return $$state.map(value => Immutable.Map({ rules: value.get('rules') }));
}

export default function cssSelectors($$state = Immutable.Map(), action) {
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
    case RESET_ALL:
      return Immutable.Map();
    default:
      return $$state;
  }
}
