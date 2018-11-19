import Immutable from 'immutable';
import subject from '../../src/store/cssSelectors';
import * as actions from '../../src/actions';

const mockRules = jest.fn();
jest.mock('../../src/utils/CssToRulesConverter', () => (
  jest.fn().mockImplementation(
    () => ({ rules: mockRules })
  )
));

describe('cssSelectors', () => {
  const state = Immutable.fromJS(
    {
      '.nutrition-facts-title': {
        rules: {
          italic: true,
          fontFamily: 'Comic Sans MS'
        }
      },
      '.calories-label': {
        rules: {
          strikethrough: true
        }
      }
    }
  );

  it('returns the same state for an unknown action', () => {
    const action = { type: 'whatever' };
    expect(subject(state, action)).toEqual(state);
  });

  describe('SET_ACTIVE_SELECTOR', () => {
    describe('when it already has that selector in the state', () => {
      it('returns the same state', () => {
        const action = {
          type: actions.SET_ACTIVE_SELECTOR,
          payload: { activeSelector: '.calories-label' }
        };
        expect(subject(state, action)).toEqual(state);
      });
    });

    describe('when it does not have that selector in the state', () => {
      it('adds the original rules for that selector to the state', () => {
        mockRules.mockReturnValueOnce({ fontWeight: 'bold' });

        const action = {
          type: actions.SET_ACTIVE_SELECTOR,
          payload: { activeSelector: '.foo' }
        };
        const expectedOutput = Immutable.fromJS(
          {
            '.nutrition-facts-title': {
              rules: {
                italic: true,
                fontFamily: 'Comic Sans MS'
              }
            },
            '.calories-label': {
              rules: {
                strikethrough: true
              }
            },
            '.foo': {
              originalRules: { fontWeight: 'bold' }
            }
          }
        );
        expect(subject(state, action)).toEqual(expectedOutput);
      });
    });
  });

  describe('SET_STYLE', () => {
    it('adds the style to the selector', () => {
      const action = {
        type: actions.SET_STYLE,
        payload: {
          activeSelector: '.calories-label',
          property: 'backgroundColor',
          value: '#57FFCF'
        }
      };
      const expectedOutput = Immutable.fromJS(
        {
          '.nutrition-facts-title': {
            rules: {
              italic: true,
              fontFamily: 'Comic Sans MS'
            }
          },
          '.calories-label': {
            rules: {
              strikethrough: true,
              backgroundColor: '#57FFCF'
            }
          }
        }
      );
      expect(subject(state, action)).toEqual(expectedOutput);
    });
  });

  describe('RESET_SELECTION', () => {
    it('resets the styles for the selector', () => {
      const action = {
        type: actions.RESET_SELECTION,
        payload: { activeSelector: '.calories-label' }
      };
      const expectedOutput = Immutable.fromJS(
        {
          '.nutrition-facts-title': {
            rules: {
              italic: true,
              fontFamily: 'Comic Sans MS'
            }
          },
          '.calories-label': {
            rules: {}
          }
        }
      );
      expect(subject(state, action)).toEqual(expectedOutput);
    });
  });

  describe('RESET_ALL', () => {
    it('resets all the styles', () => {
      const action = { type: actions.RESET_ALL };
      const expectedOutput = Immutable.fromJS({});
      expect(subject(state, action)).toEqual(expectedOutput);
    });
  });
});
