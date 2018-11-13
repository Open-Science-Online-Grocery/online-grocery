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

function updateCategory(category, subcategory) {
  return (dispatch, getState) => {
    dispatch(setCategory(category, subcategory));

    const params = {
      conditionIdentifier: getState().user.conditionIdentifier,
      subcategory_id: getState().category.subcategory
    };
    fromApi.jsonApiCall(
      routes.categoryProducts(),
      params,
      data => dispatch(setProducts(data)),
      error => console.log(error)
    );
  };
}

export const categoryActionCreators = {
  setProducts,
  updateCategory
};
