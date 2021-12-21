export const errorMessageActionTypes = {
  SHOW_ERROR_MESSAGE: 'SHOW_ERROR_MESSAGE',
  DISMISS_ERROR_MESSAGE: 'DISMISS_ERROR_MESSAGE'
};

function showErrorMessage(message) {
  return {
    message,
    type: errorMessageActionTypes.SHOW_ERROR_MESSAGE
  };
}

function dismissErrorMessage() {
  return { type: errorMessageActionTypes.DISMISS_ERROR_MESSAGE };
}

export const errorMessageActionCreators = {
  showErrorMessage,
  dismissErrorMessage
};
