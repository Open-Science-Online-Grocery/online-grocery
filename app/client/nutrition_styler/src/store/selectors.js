import Immutable from 'immutable';
import { SET_STYLE } from '../actions';

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
