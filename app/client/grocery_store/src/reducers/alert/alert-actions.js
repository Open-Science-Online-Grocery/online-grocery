export const alertActionTypes = {
  SHOW_ALERT: 'SHOW_ALERT',
  DISMISS_ALERT: 'DISMISS_ALERT'
};

function showAlert(message) {
  return {
    message,
    type: alertActionTypes.SHOW_ALERT
  };
}

function dismissAlert() {
  return { type: alertActionTypes.DISMISS_ALERT };
}

export const alertActionCreators = {
  showAlert,
  dismissAlert
};
