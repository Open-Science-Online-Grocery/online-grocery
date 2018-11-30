import { alertActionTypes } from './alert-actions';

const initialAlertState = {
  visible: false,
  message: null
};

export default function alertReducer(state = initialAlertState, action) {
  switch (action.type) {
    case alertActionTypes.SHOW_ALERT:
      return {
        visible: true,
        message: action.message
      };
    case alertActionTypes.DISMISS_ALERT:
      return initialAlertState;
    default:
      return state;
  }
}
