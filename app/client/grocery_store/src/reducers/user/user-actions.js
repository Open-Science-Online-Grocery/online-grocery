import * as qs from 'query-string';

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
  };
}

export const userActionCreators = {
  setUser,
  sessionIdSubmitted
};
