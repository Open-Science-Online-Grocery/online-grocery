import { userActionTypes } from './user-actions';

const initialUserState = {
  user: null,
  conditionIdentifier: null,
  onlyAddToCartFromDetailPage: false,
  mayAddToCartByDollarAmount: false
};

export default function userReducer(state = initialUserState, action) {
  switch (action.type) {
    case userActionTypes.SET_USER:
      return Object.assign({}, state, {
        sessionId: action.sessionId,
        conditionIdentifier: action.conditionIdentifier
      });
    case userActionTypes.SET_CONDITION_DATA:
      return Object.assign({}, state, {
        onlyAddToCartFromDetailPage: action.onlyAddToCartFromDetailPage,
        mayAddToCartByDollarAmount: action.mayAddToCartByDollarAmount
      });
    default:
      return state;
  }
}
