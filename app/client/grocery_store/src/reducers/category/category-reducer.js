import { categoryActionTypes } from './category-actions';
import { userActionTypes } from '../user/user-actions';

const initialCategoryState = {
  category: null,
  subcategory: null,
  products: [],
  categories: [],
  subcategories: []
};

export default function categoryReducer(state = initialCategoryState, action) {
  switch (action.type) {
    case categoryActionTypes.SET_CATEGORY:
      return Object.assign({}, state, {
        category: action.category,
        subcategory: action.subcategory
      });

    case categoryActionTypes.SET_PRODUCTS:
      return Object.assign({}, state, {
        products: action.products
      });

    case userActionTypes.SET_CONDITION_DATA:
      return Object.assign({}, state, {
        categories: action.categories,
        subcategories: action.subcategories
      });
    default:
      return state;
  }
}
