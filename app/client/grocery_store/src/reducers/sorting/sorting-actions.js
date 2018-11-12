export const sortingActionTypes = {
  SET_CONDITION_DATA: 'SET_CONDITION_DATA'
};

function setConditionData(sortFields) {
  return {
    sortFields,
    type: sortingActionTypes.SET_CONDITION_DATA
  };
}

export const sortingActionCreators = {
  setConditionData
};
