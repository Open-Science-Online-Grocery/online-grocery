import { categoryActionTypes } from './category-actions';
import { userActionTypes } from '../user/user-actions';

const initialCategoryState = {
  category: null,
  subcategory: null,
  tag: null,
  subtag: null,
  products: [],
  categories: [],
  subcategories: [],
  tags: [],
  subtags: []
};

export default function categoryReducer(state = initialCategoryState, action) {
  const {
    categories, subcategories, products, category,
    subcategory, tags, subtags
  } = action;

  switch (action.type) {
    case categoryActionTypes.SET_CATEGORY:
      return Object.assign({}, state, {
        category,
        subcategory
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
