import { suggestionActionTypes } from './suggestion-actions';

const initialSuggestionState = {
  visible: false,
  title: null,
  product: null
};

export default function suggestionReducer(state = initialSuggestionState, action) {
  switch (action.type) {
    case suggestionActionTypes.SHOW_SUGGESTION:
      return {
        visible: true,
        title: action.title,
        product: action.product
      };
    case suggestionActionTypes.DISMISS_SUGGESTION:
      return initialSuggestionState;
    default:
      return state;
  }
}
