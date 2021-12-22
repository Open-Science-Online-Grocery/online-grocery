import * as qs from 'query-string';
import { v1 as uuidv1 } from 'uuid';
import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';
import { selectUnloggedOperations, CHECKOUT_ACTION_TYPE } from './user-reducer';
import { categoryActionCreators } from '../category/category-actions';
import { cartActionCreators } from '../cart/cart-actions';

export const userActionTypes = {
  SET_USER: 'SET_USER',
  SET_CONDITION_DATA: 'SET_CONDITION_DATA',
  RESET_ALL: 'RESET_ALL',
  OPERATION_PERFORMED: 'OPERATION_PERFORMED',
  OPERATION_LOGGED: 'OPERATION_LOGGED',
  START_CHECKOUT_PROCESSING: 'START_CHECKOUT_PROCESSING',
  CHECKOUT_FAILURE: 'CHECKOUT_FAILURE'
};

function setUser(sessionId, conditionIdentifier) {
  return {
    sessionId,
    conditionIdentifier,
    type: userActionTypes.SET_USER
  };
}

// dispatches the condition data fetched from the server. this has a shape like:
//   {
//     sortFields ['field1', 'field2'],
//     categories: [{ id: 1, name: 'Beverages' }, { id: 2, name: 'Bread' }],
//     subcategories: [
//       { id: 3, categoryId: 1, displayOrder: 1, name: 'Water' },
//       { id: 4, categoryId: 1, displayOrder: 2, name: 'Juice' },
//     tags: [{ id: 1, name: 'Vegetarian' }, { id: 2, name: 'Vegan' }],
//     subtags: [
//       { id: 3, tagId: 1, name: 'Dairy-free' },
//       { id: 4, tagId: 1, name: 'Tofu' },
//     ],
//     ...
//   }
// see `ConditionSerializer` in the rails app for details.
function setConditionData(conditionData) {
  return {
    ...conditionData,
    type: userActionTypes.SET_CONDITION_DATA
  };
}

function resetAll() {
  return { type: userActionTypes.RESET_ALL };
}

function setInitialCategory(data) {
  let subcategoryId = null;
  if (data.subcategories.length) subcategoryId = data.subcategories[0].id;
  return categoryActionCreators.updateCategory(
    data.categories[0].id,
    subcategoryId,
    null,
    'category'
  );
}

function sessionIdSubmitted(sessionId) {
  return (dispatch) => {
    dispatch(resetAll());

    const conditionIdentifier = qs.parse(window.location.search).condId;
    dispatch(setUser(sessionId, conditionIdentifier));

    const onSuccess = (data) => {
      dispatch(setConditionData(data));
      dispatch(setInitialCategory(data));
    };

    return fromApi.jsonApiCall(
      routes.condition(),
      { conditionIdentifier },
      onSuccess,
      (error) => console.log(error)
    );
  };
}

function pageViewed() {
  return (dispatch, getState) => {
    const state = getState();
    dispatch(
      logParticipantAction(
        {
          type: 'page view',
          serialPosition: state.category.page,
          selectedCategoryId: state.category.selectedCategoryId,
          selectedSubcategoryId: state.category.selectedSubcategoryId,
          selectedSubsubcategoryId: state.category.selectedSubsubcategoryId,
          selectedCategoryType: state.category.selectedCategoryType,
          searchTerm: state.search.term,
          searchType: state.search.type
        }
      )
    );
  };
}

// @param {Object} operation - object with all data sent to server
function operationPerformed(operation) {
  return {
    operation,
    type: userActionTypes.OPERATION_PERFORMED
  };
}

// @param {Object} operation - object with all data sent to server
function operationLogged(operation) {
  return {
    operation,
    type: userActionTypes.OPERATION_LOGGED
  };
}

function addOperation(attributes) {
  return (dispatch, getState) => {
    const state = getState();
    const params = {
      ...attributes,
      sessionId: state.user.sessionId,
      id: uuidv1(),
      performedAt: new Date().toISOString(),
      logged: false
    };
    dispatch(operationPerformed(params));
  };
}

function sendOperationsToServer({ onSuccess, onFailure }) {
  return (dispatch, getState) => {
    const state = getState();
    const unloggedOperations = selectUnloggedOperations(state.user);

    fromApi.jsonApiCall(
      routes.addParticipantAction(),
      {
        conditionIdentifier: state.user.conditionIdentifier,
        operations: unloggedOperations
      },
      (data) => {
        unloggedOperations.forEach((op) => dispatch(operationLogged(op)));
        onSuccess(data);
      },
      onFailure
    );
  };
}

function addCheckoutOperations() {
  return (dispatch, getState) => {
    const products = getState().cart.items;
    products.forEach((product) => {
      dispatch(
        addOperation({
          type: CHECKOUT_ACTION_TYPE,
          quantity: product.quantity,
          productId: product.id,
          serialPosition: product.serialPosition
        })
      );
    });
  };
}

function startCheckoutProcessing() {
  return { type: userActionTypes.START_CHECKOUT_PROCESSING };
}

function checkoutFailure() {
  return {
    message: 'Unable to checkout. Please try again.',
    type: userActionTypes.CHECKOUT_FAILURE
  };
}

function checkout(successCallback) {
  return (dispatch) => {
    dispatch(startCheckoutProcessing());
    dispatch(addCheckoutOperations());
    dispatch(
      sendOperationsToServer({
        onSuccess: () => {
          successCallback();
          dispatch(cartActionCreators.clearCart());
        },
        onFailure: () => dispatch(checkoutFailure())
      })
    );
  };
}

// @param {object} attributes - data about the action. at minimum should include
//   a key `type` where the value is a string indicating the action type,
//   such as 'view', 'add', 'delete', 'checkout'.
function logParticipantAction(attributes) {
  return (dispatch) => {
    dispatch(addOperation(attributes));
    dispatch(
      sendOperationsToServer({
        onSuccess: () => {},
        onFailure: (error) => console.log(error)
      })
    );
  };
}

export const userActionCreators = {
  setUser,
  sessionIdSubmitted,
  pageViewed,
  checkout,
  logParticipantAction
};
