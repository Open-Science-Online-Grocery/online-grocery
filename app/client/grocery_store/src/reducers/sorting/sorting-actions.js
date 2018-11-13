import { categoryActionCreators } from '../category/category-actions';

export const sortingActionTypes = {
  SET_SORTING: 'SET_SORTING'
};

function setSorting(selectedSortField, sortDirection) {
  return {
    selectedSortField,
    sortDirection,
    type: sortingActionTypes.SET_SORTING
  };
}

function updateSorting(selectedSortField, sortDirection) {
  return (dispatch) => {
    dispatch(setSorting(selectedSortField, sortDirection));
    dispatch(categoryActionCreators.getProducts());
  };
}

export const sortingActionCreators = {
  updateSorting
};
