import { categoryActionCreators } from '../category/category-actions';

export const filteringActionTypes = {
  SET_FILTER: 'SET_FILTER'
};

function setFilter(selectedFilterId) {
  return {
    selectedFilterId,
    type: filteringActionTypes.SET_FILTER
  };
}

function updateFilter(selectedFilterId) {
  return (dispatch) => {
    dispatch(setFilter(selectedFilterId));
    dispatch(categoryActionCreators.getProducts());
  };
}

export const filteringActionCreators = {
  updateFilter
};
