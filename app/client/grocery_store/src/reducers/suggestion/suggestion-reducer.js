// import { alertActionTypes } from './alert-actions';

const initialSuggestionState = {
  visible: false,
  title: null,
  product: null
};

export default function alertReducer(state = initialSuggestionState, action) {
  switch (action.type) {
    // case alertActionTypes.SHOW_ALERT:
    //   return {
    //     visible: true,
    //     message: action.message
    //   };
    // case alertActionTypes.DISMISS_ALERT:
    //   return initialAlertState;
    default:
      return state;
  }
}
