export const userActionTypes = {
  SET_USER: 'SET_USER'
};

function setUser(sessionID) {
  return {
    sessionID,
    type: userActionTypes.SET_USER
  };
}

export const userActionCreators = {
  setUser
};
