import { combineReducers } from 'redux';
import { sortingActionTypes } from './sorting-actions';

function sortFields(state = [], action) {
  switch (action.type) {
    case sortingActionTypes.SET_CONDITION_DATA:
      return action.sortFields;
    default:
      return state;
  }
}

const sorting = combineReducers({
  sortFields
});

export default sorting;
