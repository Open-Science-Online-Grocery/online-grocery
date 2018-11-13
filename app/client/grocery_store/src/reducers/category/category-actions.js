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

export const categoryActionCreators = {
  setCategory,
  setProducts
};
