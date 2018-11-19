import Immutable from 'immutable';
import * as actions from '../../src/actions';
import subject, * as fromSubject from '../../src/store';

describe('reducers', () => {
  describe('rootReducer', () => {
    it('returns an initial state', () => {
      const initialState = subject(undefined, {});
      expect(initialState.get('activeSelector')).toEqual(null);
      expect(initialState.get('cssSelectors')).toEqual(Immutable.Map());
    });
  });

  describe('activeSelector', () => {
    const state = '.calories-label';

    it('returns the same state for an unknown action', () => {
      const action = { type: 'whatever' };
      expect(fromSubject.activeSelector(state, action)).toEqual(state);
    });

    it('returns the new selector for SET_ACTIVE_SELECTOR', () => {
      const action = {
        type: actions.SET_ACTIVE_SELECTOR,
        payload: { activeSelector: '.foo' }
      };
      expect(fromSubject.activeSelector(state, action)).toEqual('.foo');
    });
  });
});
