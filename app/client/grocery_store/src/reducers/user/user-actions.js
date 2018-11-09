export const userActionTypes = {
  SET_USER: 'SET_USER'
};

function setUser(sessionID, conditionIdentifier) {
  return {
    sessionID,
    conditionIdentifier,
    type: userActionTypes.SET_USER
  };
}

export const userActionCreators = {
  setUser
};
