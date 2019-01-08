import Immutable from 'immutable';
import * as actions from '../../src/actions';
import subject, * as fromSubject from '../../src/store';

describe('reducers', () => {
  describe('rootReducer', () => {
    it('returns an initial state', () => {
      const initialState = subject(undefined, {});
      expect(initialState.get('cursorPosition')).toEqual(0);
      expect(initialState.get('tokens')).toEqual(Immutable.List());
      expect(initialState.get('valid')).toEqual(null);
      expect(initialState.get('validationMessage')).toEqual(null);
      expect(initialState.get('variables')).toEqual(Immutable.Map());
      expect(initialState.get('inputName')).toEqual('');
      expect(initialState.get('equationType')).toEqual('');
    });
  });

  describe('cursorPosition', () => {
    let state = 7;

    it('returns the same state for an unknown action', () => {
      const action = { type: 'whatever' };
      expect(fromSubject.cursorPosition(state, action)).toEqual(state);
    });

    it('returns one larger for INSERT_TOKEN', () => {
      const action = {
        type: actions.INSERT_TOKEN
      };
      expect(fromSubject.cursorPosition(state, action)).toEqual(8);
    });

    it('returns one larger if cursor should move forward', () => {
      const action = {
        type: actions.MOVE_CURSOR,
        payload: { shouldMoveForwards: true, tokenCount: 11 }
      };
      expect(fromSubject.cursorPosition(state, action)).toEqual(8);
    });

    it('stays the same if cursor should move forward but token count is too low', () => {
      const action = {
        type: actions.MOVE_CURSOR,
        payload: { shouldMoveForwards: true, tokenCount: 7 }
      };
      expect(fromSubject.cursorPosition(state, action)).toEqual(7);
    });


    it('returns one lower if cursor should move backward', () => {
      const action = {
        type: actions.MOVE_CURSOR,
        payload: { shouldMoveForwards: false }
      };
      expect(fromSubject.cursorPosition(state, action)).toEqual(6);
    });

    it('stays the same if cursor should move backward but is already at 0', () => {
      state = 0;
      const action = {
        type: actions.MOVE_CURSOR,
        payload: { shouldMoveForwards: false }
      };
      expect(fromSubject.cursorPosition(state, action)).toEqual(0);
    });
  });

  describe('tokens', () => {
    const state = Immutable.fromJS(
      [
        { id: 'a', type: 'variable', value: 'calories' },
        { id: 'b', type: 'operator', value: '>' },
        { id: 'c', type: 'digit', value: '2' }
      ]
    );

    it('returns the same state for an unknown action', () => {
      const action = { type: 'whatever' };
      expect(fromSubject.tokens(state, action)).toEqual(state);
    });

    it('adds a token for INSERT_TOKEN', () => {
      const action = {
        type: actions.INSERT_TOKEN,
        payload: { position: 2, type: 'digit', value: '5' }
      };
      const result = fromSubject.tokens(state, action);
      expect(result.getIn([2, 'value'])).toEqual('5');
      expect(result.getIn([1, 'value'])).toEqual('>');
      expect(result.getIn([3, 'value'])).toEqual('2');
    });

    it('removes a token for REMOVE_TOKEN', () => {
      const action = {
        type: actions.REMOVE_TOKEN,
        payload: { position: 1 }
      };
      const expectedOutput = Immutable.fromJS(
        [
          { id: 'a', type: 'variable', value: 'calories' },
          { id: 'c', type: 'digit', value: '2' }
        ]
      );
      expect(fromSubject.tokens(state, action)).toEqual(expectedOutput);
    });
  });

  describe('valid', () => {
    const state = true;

    it('returns the same state for an unknown action', () => {
      const action = { type: 'whatever' };
      expect(fromSubject.valid(state, action)).toEqual(state);
    });

    it('returns the payload result for REPORT_TEST_RESULTS', () => {
      const action = {
        type: actions.REPORT_TEST_RESULTS,
        payload: { valid: false }
      };
      expect(fromSubject.valid(state, action)).toEqual(false);
    });

    it('resets to null for INSERT_TOKEN', () => {
      const action = {
        type: actions.INSERT_TOKEN
      };
      expect(fromSubject.valid(state, action)).toEqual(null);
    });

    it('resets to null for REMOVE_TOKEN', () => {
      const action = {
        type: actions.REMOVE_TOKEN
      };
      expect(fromSubject.valid(state, action)).toEqual(null);
    });
  });

  describe('validationMessage', () => {
    const state = 'error!';

    it('returns the same state for an unknown action', () => {
      const action = { type: 'whatever' };
      expect(fromSubject.validationMessage(state, action)).toEqual(state);
    });

    it('returns the payload message for REPORT_TEST_RESULTS', () => {
      const action = {
        type: actions.REPORT_TEST_RESULTS,
        payload: { validationMessage: 'goodbye!' }
      };
      expect(fromSubject.validationMessage(state, action)).toEqual('goodbye!');
    });

    it('resets to null for INSERT_TOKEN', () => {
      const action = {
        type: actions.INSERT_TOKEN
      };
      expect(fromSubject.validationMessage(state, action)).toEqual(null);
    });

    it('resets to null for REMOVE_TOKEN', () => {
      const action = {
        type: actions.REMOVE_TOKEN
      };
      expect(fromSubject.validationMessage(state, action)).toEqual(null);
    });
  });
});

describe('selectors', () => {
  describe('getVariables', () => {
    it('returns the variables', () => {
      const state = Immutable.fromJS({ variables: [{ foo: 'bar' }] });
      expect(fromSubject.getVariables(state)).toEqual([{ foo: 'bar' }]);
    });
  });

  describe('getCursorPosition', () => {
    it('returns the cursor position', () => {
      const state = Immutable.fromJS({ cursorPosition: 11 });
      expect(fromSubject.getCursorPosition(state)).toEqual(11);
    });
  });

  describe('getInputName', () => {
    it('returns the input name', () => {
      const state = Immutable.fromJS({ inputName: 'zzz' });
      expect(fromSubject.getInputName(state)).toEqual('zzz');
    });
  });

  describe('getEquationType', () => {
    it('returns the equation type', () => {
      const state = Immutable.fromJS({ equationType: 'label' });
      expect(fromSubject.getEquationType(state)).toEqual('label');
    });
  });

  describe('getValid', () => {
    it('returns the validity', () => {
      const state = Immutable.fromJS({ valid: false });
      expect(fromSubject.getValid(state)).toEqual(false);
    });
  });

  describe('getValidationMessage', () => {
    it('returns the validation message', () => {
      const state = Immutable.fromJS({ validationMessage: 'whoops, my bad' });
      expect(fromSubject.getValidationMessage(state)).toEqual('whoops, my bad');
    });
  });

  describe('token-related functions', () => {
    const state = Immutable.fromJS(
      {
        tokens: [
          { id: 'a', type: 'variable', value: 'calories' },
          { id: 'b', type: 'operator', value: '+' },
          { id: 'c', type: 'variable', value: 'sodium' },
          { id: 'd', type: 'operator', value: '>' },
          { id: 'e', type: 'digit', value: '2' }
        ],
        variables: [
          {
            token: 'calories',
            description: 'Calories per serving',
            incompleteData: false
          },
          {
            token: 'sodium',
            description: 'Sodium per serving',
            incompleteData: true
          }
        ]
      }
    );

    describe('getTokenCount', () => {
      it('returns the tokens as JS', () => {
        expect(fromSubject.getTokenCount(state)).toEqual(5);
      });
    });

    describe('getTokensWithName', () => {
      it('returns the variable name when token is a variable', () => {
        const expectedOutput = [
          {
            id: 'a',
            type: 'variable',
            value: 'calories',
            name: 'Calories per serving'
          },
          {
            id: 'b',
            type: 'operator',
            value: '+',
            name: null
          },
          {
            id: 'c',
            type: 'variable',
            value: 'sodium',
            name: 'Sodium per serving'
          },
          {
            id: 'd',
            type: 'operator',
            value: '>',
            name: null
          },
          {
            id: 'e',
            type: 'digit',
            value: '2',
            name: null
          }
        ];
        expect(fromSubject.getTokensWithName(state)).toEqual(expectedOutput);
      });
    });

    describe('getTokensJson', () => {
      it('returns the tokens as JSON', () => {
        const expectedOutput = '[{"id":"a","type":"variable","value":"calories"},{"id":"b","type":"operator","value":"+"},{"id":"c","type":"variable","value":"sodium"},{"id":"d","type":"operator","value":">"},{"id":"e","type":"digit","value":"2"}]';
        expect(fromSubject.getTokensJson(state)).toEqual(expectedOutput);
      });
    });

    describe('getIncompleteDataVariables', () => {
      it('returns the expected variable descriptions', () => {
        expect(fromSubject.getIncompleteDataVariables(state)).toEqual(
          ['Sodium per serving']
        );
      });
    });
  });
});
