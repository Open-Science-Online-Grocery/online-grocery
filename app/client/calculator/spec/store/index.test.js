import Immutable from 'immutable';
import subject, * as fromSubject from '../../src/store';

const mockPreparedData = jest.fn();

describe('reducers', () => {
  describe('rootReducer', () => {
    it('returns an initial state', () => {
      const initialState = subject(undefined, {});
      expect(initialState.get('equationType')).toEqual('');
    });
  });
});
