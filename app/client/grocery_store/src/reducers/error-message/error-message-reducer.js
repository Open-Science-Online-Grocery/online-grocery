import { errorMessageActionTypes } from './error-message-actions';

const initialState = {
  visible: false,
  message: null
};

export default function errorMessageReducer(state = initialState, action) {
  switch (action.type) {
    case errorMessageActionTypes.SHOW_ERROR_MESSAGE:
      return {
        visible: true,
        message: action.message
      };
    case errorMessageActionTypes.DISMISS_ERROR_MESSAGE:
      return initialState;
    default:
      return state;
  }
}
