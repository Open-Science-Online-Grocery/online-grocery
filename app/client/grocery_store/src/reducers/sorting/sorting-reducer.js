import { combineReducers } from 'redux';
import { userActionTypes } from '../user/user-actions';
import { sortingActionTypes } from './sorting-actions';

function sortFields(state = [], action) {
  switch (action.type) {
    case userActionTypes.SET_CONDITION_DATA:
      return action.sortFields;
    default:
      return state;
  }
}

function selectedSortField(state = null, action) {
  switch (action.type) {
    case sortingActionTypes.SET_SORTING:
      return action.selectedSortField;
    default:
      return state;
  }
}

function sortDirection(state = null, action) {
  switch (action.type) {
    case sortingActionTypes.SET_SORTING:
      return action.sortDirection;
    default:
      return state;
  }
}

function filterByTags(state = null, action) {
  switch (action.type) {
    case userActionTypes.SET_CONDITION_DATA:
      return action.filterByTags;
    default:
      return state;
  }
}

const sorting = combineReducers({
  sortFields,
  selectedSortField,
  sortDirection,
  filterByTags
});

export default sorting;
