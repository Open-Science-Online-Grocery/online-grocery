import { userActionTypes } from './user-actions';

const initialUserState = {
  user: null,
  conditionIdentifier: null,
  onlyAddToCartFromDetailPage: false,
  mayAddToCartByDollarAmount: false,
  showGuidingStars: true,
  qualtricsCode: null,
  showProductsBySubcategory: true,
  allowSearching: true
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
        mayAddToCartByDollarAmount: action.mayAddToCartByDollarAmount,
        showGuidingStars: action.showGuidingStars,
        qualtricsCode: action.qualtricsCode,
        showProductsBySubcategory: action.showProductsBySubcategory,
        allowSearching: action.allowSearching
      });
    default:
      return state;
  }
}
