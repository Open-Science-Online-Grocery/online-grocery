import { categoryActionCreators } from '../category/category-actions';

export const searchActionTypes = {
  SET_SEARCH_TERM: 'SET_SEARCH_TERM',
  SET_SEARCH_TYPE: 'SET_SEARCH_TYPE'
};

function setSearchTerm(searchTerm) {
  return {
    searchTerm,
    type: searchActionTypes.SET_SEARCH_TERM
  };
}

function setSearchType(searchType) {
  return {
    searchType,
    type: searchActionTypes.SET_SEARCH_TYPE
  };
}

function updateSearchTerm(searchTerm) {
  return (dispatch) => {
    dispatch(setSearchType('term'));
    dispatch(setSearchTerm(searchTerm));
    dispatch(categoryActionCreators.getProducts());
  };
}

function updateSearchType(searchType) {
  return (dispatch) => {
    dispatch(setSearchType(searchType));
    dispatch(categoryActionCreators.getProducts());
  };
}

export const searchActionCreators = {
  updateSearchTerm,
  updateSearchType
};
