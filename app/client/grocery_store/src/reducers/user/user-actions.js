import * as qs from 'query-string';
import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';

export const userActionTypes = {
  SET_USER: 'SET_USER',
  SET_CONDITION_DATA: 'SET_CONDITION_DATA'
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
//     ]
//   }
function setConditionData(conditionData) {
  return {
    ...conditionData,
    type: userActionTypes.SET_CONDITION_DATA
  };
}

function sessionIdSubmitted(sessionId) {
  return (dispatch) => {
    const conditionIdentifier = qs.parse(window.location.search).condId;
    dispatch(setUser(sessionId, conditionIdentifier));

    return fromApi.jsonApiCall(
      routes.condition(),
      { conditionIdentifier },
      data => dispatch(setConditionData(data)),
      error => console.log(error)
    );
  };
}

export const userActionCreators = {
  setUser,
  sessionIdSubmitted
};
