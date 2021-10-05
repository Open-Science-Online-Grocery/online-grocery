import * as qs from 'query-string';
import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';
import { categoryActionCreators } from '../category/category-actions';

export const userActionTypes = {
  SET_USER: 'SET_USER',
  SET_CONDITION_DATA: 'SET_CONDITION_DATA',
  RESET_ALL: 'RESET_ALL'
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
//     ]
//   }
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
  const subcategoryId = null;
  if (data.subcategories.length) subcategoryId = data.subcategories[0].id;
  return categoryActionCreators.updateCategory(
    data.categories[0].id,
    subcategoryId,
    null,
    'category'
  )
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
      error => console.log(error)
    );
  };
}

// `actionType` here is a string representing the action the participant has
// taken, such as 'view', 'add', 'delete', 'checkout'
function logParticipantAction(actionType, product, quantity) {
  return (dispatch, getState) => {
    const state = getState();
    const params = {
      actionType,
      quantity,
      productId: product.id,
      serialPosition: product.serialPosition,
      sessionId: state.user.sessionId,
      conditionIdentifier: state.user.conditionIdentifier
    };
    fromApi.jsonApiCall(
      routes.addParticipantAction(),
      params,
      data => console.log(data),
      error => console.log(error)
    );
  };
}

export const userActionCreators = {
  setUser,
  sessionIdSubmitted,
  logParticipantAction
};
