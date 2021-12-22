import { userActionTypes } from './user-actions';

export const CHECKOUT_ACTION_TYPE = 'checkout';

const initialUserState = {
  user: null,
  conditionIdentifier: null,
  onlyAddToCartFromDetailPage: false,
  mayAddToCartByDollarAmount: false,
  showGuidingStars: true,
  qualtricsCode: null,
  showProductsBySubcategory: true,
  allowSearching: true,
  // this maps onto ParticipantActions on the Rails side, but we're calling it
  // `operations` to avoid the term `action` which has special meaning in redux.
  operations: []
};

/* ****************************** selectors ********************************* */

export function selectUnloggedOperations(state) {
  return state.operations.filter((operation) => !operation.logged);
}

/* ******************************* reducer ********************************** */

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
    case userActionTypes.OPERATION_PERFORMED:
      return Object.assign({}, state, {
        operations: [...state.operations, action.operation]
      });
    case userActionTypes.OPERATION_LOGGED:
      return Object.assign({}, state, {
        operations: state.operations.map((operation) => {
          if (operation.id === action.operation.id) {
            return Object.assign({}, operation, { logged: true });
          }
          return operation;
        })
      });
    case userActionTypes.CHECKOUT_FAILURE:
      return Object.assign({}, state, {
        operations: state.operations.filter(
          (operation) => operation.type !== CHECKOUT_ACTION_TYPE
        )
      });
    default:
      return state;
  }
}
