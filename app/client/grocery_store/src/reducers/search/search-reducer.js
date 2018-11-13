import { combineReducers } from 'redux';

import { searchActionTypes } from './search-actions';

function term(state = null, action) {
  switch (action.type) {
    case searchActionTypes.SET_SEARCH_TERM:
      return action.searchTerm;
    default:
      return state;
  }
}

function type(state = 'category', action) {
  switch (action.type) {
    case searchActionTypes.SET_SEARCH_TYPE:
      return action.searchType;
    default:
      return state;
  }
}

const search = combineReducers({
  term,
  type
});

export default search;
