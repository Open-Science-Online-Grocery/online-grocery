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

export const sortingActionCreators = {
  setSorting
};
