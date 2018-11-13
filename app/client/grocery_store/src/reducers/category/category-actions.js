import * as routes from '../../../../utils/routes';
import * as fromApi from '../../../../utils/api_call';

export const categoryActionTypes = {
  SET_CATEGORY: 'SET_CATEGORY',
  SET_PRODUCTS: 'SET_PRODUCTS'
};

function setCategory(category, subcategory) {
  return {
    category,
    subcategory,
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
      conditionIdentifier: state.user.conditionIdentifier,
      subcategory_id: state.category.subcategory,
      searchTerm: state.search.term,
      searchType: state.search.type
    };
    fromApi.jsonApiCall(
      routes.categoryProducts(),
      params,
      data => dispatch(setProducts(data)),
      error => console.log(error)
    );
  };
}

function updateCategory(category, subcategory) {
  return (dispatch) => {
    dispatch(setCategory(category, subcategory));
    dispatch(getProducts());
  };
}

export const categoryActionCreators = {
  updateCategory,
  getProducts
};
