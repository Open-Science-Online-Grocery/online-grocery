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
});
