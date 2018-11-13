export const sortingActionTypes = {
  SET_CONDITION_DATA: 'SET_CONDITION_DATA',
  SET_SORTING: 'SET_SORTING'
};

function setConditionData(sortFields) {
  return {
    sortFields,
    type: sortingActionTypes.SET_CONDITION_DATA
  };
}

function setSorting(selectedSortField, sortDirection) {
  return {
    selectedSortField,
    sortDirection,
    type: sortingActionTypes.SET_SORTING
  };
}

export const sortingActionCreators = {
  setConditionData,
  setSorting
};
