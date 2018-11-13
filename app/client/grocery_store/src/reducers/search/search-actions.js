import { categoryActionCreators } from '../category/category-actions';

export const searchActionTypes = {
  SET_SEARCH: 'SET_SEARCH'
};

function setSearch(search) {
  return {
    search,
    type: searchActionTypes.SET_SEARCH
  };
}

function updateSearch(search) {
  return (dispatch) => {
    dispatch(setSearch(search));
    dispatch(categoryActionCreators.getProducts());
  };
}

export const searchActionCreators = {
  updateSearch
};
