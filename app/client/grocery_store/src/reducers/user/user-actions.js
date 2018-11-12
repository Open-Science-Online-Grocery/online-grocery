import * as qs from 'query-string';
import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';
import { sortingActionCreators } from '../sorting/sorting-actions';

export const userActionTypes = {
  SET_USER: 'SET_USER'
};

function setUser(sessionId, conditionIdentifier) {
  return {
    sessionId,
    conditionIdentifier,
    type: userActionTypes.SET_USER
  };
}

function sessionIdSubmitted(sessionId) {
  return (dispatch) => {
    const conditionIdentifier = qs.parse(window.location.search).condId;
    dispatch(setUser(sessionId, conditionIdentifier));

    return fromApi.jsonApiCall(
      routes.condition(),
      { conditionIdentifier },
      data => dispatch(sortingActionCreators.setConditionData(data.sortFields)),
      error => console.log(error)
    );
  };
}

export const userActionCreators = {
  setUser,
  sessionIdSubmitted
};
