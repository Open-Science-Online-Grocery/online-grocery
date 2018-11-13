import { searchActionTypes } from './search-actions';

export default function search(state = null, action) {
  switch (action.type) {
    case searchActionTypes.SET_SEARCH:
      return action.search;
    default:
      return state;
  }
}
