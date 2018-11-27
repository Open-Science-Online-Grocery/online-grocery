import { categoryActionTypes } from './category-actions';
import { userActionTypes } from '../user/user-actions';

const initialCategoryState = {
  selectedCategoryId: null,
  selectedSubcategoryId: null,
  selectedCategoryType: null,
  products: [],
  categories: [],
  subcategories: [],
  tags: [],
  subtags: []
};

export default function categoryReducer(state = initialCategoryState, action) {
  const {
    categories, subcategories, products, selectedCategoryId,
    selectedSubcategoryId, tags, subtags, selectedCategoryType
  } = action;

  switch (action.type) {
    case categoryActionTypes.SET_CATEGORY:
      return Object.assign({}, state, {
        selectedCategoryId,
        selectedSubcategoryId,
        selectedCategoryType
      });
    case categoryActionTypes.SET_PRODUCTS:
      return Object.assign({}, state, {
        products
      });
    case userActionTypes.SET_CONDITION_DATA:
      return Object.assign({}, state, {
        categories,
        subcategories,
        tags,
        subtags
      });
    default:
      return state;
  }
}
