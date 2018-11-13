export const searchActionTypes = {
  SET_SEARCH: 'SET_SEARCH'
};

function setSearch(search) {
  return {
    search,
    type: searchActionTypes.SET_SEARCH
  };
}

export const searchActionCreators = {
  setSearch
};
