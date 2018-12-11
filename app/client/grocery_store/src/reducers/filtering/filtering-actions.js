import { categoryActionCreators } from '../category/category-actions';

export const filteringActionTypes = {
  SET_FILTER: 'SET_FILTER'
};

function setFilter(selectedFilterId, selectedFilterType) {
  return {
    selectedFilterId,
    selectedFilterType,
    type: filteringActionTypes.SET_FILTER
  };
}

function updateFilter(selectedFilterId, selectedFilterType) {
  return (dispatch) => {
    dispatch(setFilter(selectedFilterId, selectedFilterType));
    dispatch(categoryActionCreators.getProducts());
  };
}

export const filteringActionCreators = {
  updateFilter
};
