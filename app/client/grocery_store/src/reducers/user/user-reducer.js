import { userActionTypes } from './user-actions';

const initialUserState = { user: null };

export default function userReducer(state = initialUserState, action) {
  switch (action.type) {
    case userActionTypes.SET_USER:
      return Object.assign({}, state, {
        sessionId: action.sessionId,
        conditionIdentifier: action.conditionIdentifier
      });
    default:
      return state;
  }
}
