import { combineReducers } from 'redux';
import { userActionTypes } from '../user/user-actions';
import { filteringActionTypes } from './filtering-actions';

function selectedFilterId(state = null, action) {
  switch (action.type) {
    case filteringActionTypes.SET_FILTER:
      return action.selectedFilterId;
    default:
      return state;
  }
}

function selectedFilterType(state = null, action) {
  switch (action.type) {
    case filteringActionTypes.SET_FILTER:
      return action.selectedFilterType;
    default:
      return state;
  }
}

function filterByTags(state = false, action) {
  switch (action.type) {
    case userActionTypes.SET_CONDITION_DATA:
      return action.filterByTags;
    default:
      return state;
  }
}

const filtering = combineReducers({
  filterByTags,
  selectedFilterId,
  selectedFilterType
});

export default filtering;
