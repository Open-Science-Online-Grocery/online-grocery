export const suggestionActionTypes = {
  SHOW_SUGGESTION: 'SHOW_SUGGESTION',
  DISMISS_SUGGESTION: 'DISMISS_SUGGESTION'
};

function showSuggestion(title, product) {
  return {
    title,
    product,
    type: suggestionActionTypes.SHOW_SUGGESTION
  };
}

function dismissSuggestion() {
  return { type: suggestionActionTypes.DISMISS_SUGGESTION };
}

export const suggestionActionCreators = {
  showSuggestion,
  dismissSuggestion
};
