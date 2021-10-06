import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';

export const categoryActionTypes = {
  SET_CATEGORY: 'SET_CATEGORY',
  SET_PRODUCTS: 'SET_PRODUCTS'
};

function setCategory(
  selectedCategoryId, selectedSubcategoryId, selectedSubsubcategoryId, selectedCategoryType
) {
  return {
    selectedCategoryId,
    selectedSubcategoryId,
    selectedSubsubcategoryId,
    selectedCategoryType,
    type: categoryActionTypes.SET_CATEGORY
  };
}

function setProducts(products) {
  return {
    products,
    type: categoryActionTypes.SET_PRODUCTS
  };
}

function getProducts() {
  return (dispatch, getState) => {
    const state = getState();
    const params = {
      sessionIdentifier: state.user.sessionId,
      conditionIdentifier: state.user.conditionIdentifier,
      selectedCategoryId: state.category.selectedCategoryId,
      selectedSubcategoryId: state.category.selectedSubcategoryId,
      selectedSubsubcategoryId: state.category.selectedSubsubcategoryId,
      selectedCategoryType: state.category.selectedCategoryType,
      searchTerm: state.search.term,
      searchType: state.search.type,
      sortField: state.sorting.selectedSortField,
      sortDirection: state.sorting.sortDirection,
      selectedFilterId: state.filtering.selectedFilterId,
      selectedFilterType: state.filtering.selectedFilterType
    };
    fromApi.jsonApiCall(
      routes.products(),
      params,
      data => dispatch(setProducts(data)),
      error => console.log(error)
    );
  };
}

function updateCategory(
  selectedCategoryId, selectedSubcategoryId, selectedSubsubcategoryId, selectedCategoryType
) {
  return (dispatch) => {
    dispatch(setCategory(
      selectedCategoryId,
      selectedSubcategoryId,
      selectedSubsubcategoryId,
      selectedCategoryType
    ));
    dispatch(getProducts());
  };
}

export const categoryActionCreators = {
  updateCategory,
  getProducts
};
